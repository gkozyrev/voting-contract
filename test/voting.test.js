const {expectRevert} = require('@openzeppelin/test-helpers');
const {assert} = require('chai');

const Voting = artifacts.require('Voting');

contract('Voting', ([alice, bob, carol, alex]) => {
    beforeEach(async () => {
        this.voting = await Voting.new({from: alice});
    });

    it('Full cycle with reverts and asserts', async () => {
        await expectRevert(this.voting.addAnswer(2, "Question"), "Voting: Poll doesn't exist");
        await this.voting.createPoll('Coffee poll', 'Do you like coffee?', {from: alice});

        await this.voting.addWhitelistAddress('0', bob);

        await this.voting.addManyWhitelistAddress('0', [bob, carol]);

        this.voting.addAnswer(0, "Yes");
        this.voting.addAnswer(0, "No");
        await this.voting.startPoll(0);

        assert(await this.voting.getAnswer.call('0', '0'), 'Yes');
        assert(await this.voting.getAnswer.call('0', '1'), 'No');

        await expectRevert(this.voting.addAnswer(0, "I don't know"), "Voting: Poll is already started");
        assert(await this.voting.getAnswer.call('0', '1'), 'No');

        let answerIdRange = await this.voting.getAnswersIdRange.call('0');
        assert(answerIdRange[0], 0)
        assert(answerIdRange[1], 1)

        assert(await this.voting.getAnswerVotes.call('0', '0'), 0)

        await this.voting.vote('0', '0', {from: alice});
        await this.voting.vote('0', '1', {from: bob});
        await this.voting.vote('0', '1', {from: carol});

        assert(await this.voting.getAnswerVotes.call('0', '0'), 1);
        assert(await this.voting.getAnswerVotes.call('0', '1'), 2);

        await this.voting.closePoll('0')

        await expectRevert(this.voting.vote('0', '0', {from: alice}), "Voting: Poll is already closed");
    });

    it('Full cycle clean', async () => {
        await this.voting.createPoll('Coffee poll', 'Do you like coffee?', {from: alice});

        await this.voting.addWhitelistAddress('0', alex);

        await this.voting.addManyWhitelistAddress('0', [bob, carol]);

        this.voting.addAnswer(0, "Yes");
        this.voting.addAnswer(0, "No");
        this.voting.addAnswer(0, "I don't know");
        await this.voting.startPoll(0);

        assert(await this.voting.getAnswer.call('0', '0'), 'Yes');
        assert(await this.voting.getAnswer.call('0', '1'), 'No');
        assert(await this.voting.getAnswer.call('0', '2'), "I don't know");

        let answerIdRange = await this.voting.getAnswersIdRange.call('0');
        assert(answerIdRange[0], 0)
        assert(answerIdRange[1], 2)

        assert(await this.voting.getAnswerVotes.call('0', '0'), 0)

        await this.voting.vote('0', '0', {from: alice});
        await this.voting.vote('0', '1', {from: bob});
        await this.voting.vote('0', '1', {from: carol});
        await this.voting.vote('0', '1', {from: alex});

        assert(await this.voting.getAnswerVotes.call('0', '0'), 1);
        assert(await this.voting.getAnswerVotes.call('0', '1'), 3);

        await this.voting.closePoll('0')
    });
});
