// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import {IPredictDotLoan} from "../../contracts/interfaces/IPredictDotLoan.sol";

import {PredictDotLoan_Test} from "./PredictDotLoan.t.sol";

contract PredictDotLoan_AcceptLoanOffer_NegRisk_Test is PredictDotLoan_Test {
    function test_acceptLoanOffer_NegRisk_RevertIf_MarketResolved() public {
        IPredictDotLoan.Proposal memory proposal = _generateLoanOffer(IPredictDotLoan.QuestionType.NegRisk);

        mockNegRiskAdapter.setDetermined(negRiskQuestionId, true);

        vm.expectRevert(IPredictDotLoan.MarketResolved.selector);
        vm.prank(borrower);
        predictDotLoan.acceptLoanOffer(proposal, proposal.loanAmount);
    }
}
