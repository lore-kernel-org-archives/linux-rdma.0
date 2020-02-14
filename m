Return-Path: <SRS0=HMeR=4C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE19C3B1A1
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 17:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ECC5222C2
	for <linux-rdma@archiver.kernel.org>; Fri, 14 Feb 2020 17:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391317AbgBNRY7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:24:59 -0500
Received: from mga17.intel.com ([192.55.52.151]:43172 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390928AbgBNRY7 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 14 Feb 2020 12:24:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 09:24:56 -0800
X-IronPort-AV: E=Sophos;i="5.70,441,1574150400"; 
   d="scan'208";a="223081205"
Received: from ddalessa-mobl.amr.corp.intel.com (HELO [10.254.204.146]) ([10.254.204.146])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 14 Feb 2020 09:24:54 -0800
Subject: Re: [PATCH 1/3] infiniband: hw: hfi1: verbs.c: Use built-in RCU list
 checking
To:     Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     mike.marciniszyn@intel.com,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Amol Grover <frextrite@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        rcu@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200114162345.19995-1-madhuparnabhowmik04@gmail.com>
 <20200114165740.GB22037@ziepe.ca>
 <74adec84-ec5b-ea1b-7adf-3f8608838259@intel.com>
 <25133367-6544-d0af-ae30-5178909748b1@intel.com>
 <CAF65HP0RsW5FMRRf5Lia2=MTKex-KwO7-_NsCUef94YKBg+pfA@mail.gmail.com>
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
Message-ID: <c773894a-b011-2419-683a-3b851583fc73@intel.com>
Date:   Fri, 14 Feb 2020 12:24:52 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <CAF65HP0RsW5FMRRf5Lia2=MTKex-KwO7-_NsCUef94YKBg+pfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 2/14/2020 10:43 AM, Madhuparna Bhowmik wrote:
> 
> 
> On Wed, Jan 15, 2020 at 12:05 AM <madhuparnabhowmik04@gmail.com 
> <mailto:madhuparnabhowmik04@gmail.com>> wrote:
> 
>     From: Dennis Dalessandro <dennis.dalessandro@intel.com
>     <mailto:dennis.dalessandro@intel.com>>
> 
>     On 1/14/2020 12:00 PM, Dennis Dalessandro wrote:
>      > On 1/14/2020 11:57 AM, Jason Gunthorpe wrote:
>      >> On Tue, Jan 14, 2020 at 09:53:45PM +0530,
>      >> madhuparnabhowmik04@gmail.com
>     <mailto:madhuparnabhowmik04@gmail.com> wrote:
>      >>> From: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com
>     <mailto:madhuparnabhowmik04@gmail.com>>
>      >>>
>      >>> list_for_each_entry_rcu has built-in RCU and lock checking.
>      >>> Pass cond argument to list_for_each_entry_rcu.
>      >>>
>      >>> Signed-off-by: Madhuparna Bhowmik
>     <madhuparnabhowmik04@gmail.com <mailto:madhuparnabhowmik04@gmail.com>>
>      >>>   drivers/infiniband/hw/hfi1/verbs.c | 2 +-
>      >>>   1 file changed, 1 insertion(+), 1 deletion(-)
>      >>>
>      >>> diff --git a/drivers/infiniband/hw/hfi1/verbs.c
>      >>> b/drivers/infiniband/hw/hfi1/verbs.c
>      >>> index 089e201d7550..22f2d4fd2577 100644
>      >>> +++ b/drivers/infiniband/hw/hfi1/verbs.c
>      >>> @@ -515,7 +515,7 @@ static inline void hfi1_handle_packet(struct
>      >>> hfi1_packet *packet,
>      >>>                          opa_get_lid(packet->dlid, 9B));
>      >>>           if (!mcast)
>      >>>               goto drop;
>      >>> -        list_for_each_entry_rcu(p, &mcast->qp_list, list) {
>      >>> +        list_for_each_entry_rcu(p, &mcast->qp_list, list,
>      >>> lockdep_is_held(&(ibp->rvp.lock))) {
>      >>
>      >> Okay, this looks reasonable
>      >>
>      >> Mike, Dennis, is this the right lock to test?
>      >>
>      >
>      > I'm looking at that right now actually, I don't think this is
>     correct.
>      > Wanted to talk to Mike before I send a response though.
>      >
>      > -Denny
> 
>     That's definitely going to throw a ton of lock dep messages. It's not
>     really the right lock either. Instead what we probably need to do is
>     what we do in the non-multicast part of the code and take the
>     rcu_read_lock().
> 
>     I'd say hold off on this and we'll fix it right. Same goes for the
>     qib one.
> 
>     Alright, thank you for reviewing.
> 
>     The rdmavt one though looks to be OK. I'll give it a test.
> 
> Hi,
> I just wanted to follow up on this.
> Any updates?
> Also, is the bug fixed now?
> 
> Thank you,
> Madhuparna
> 
>     Thank you,
>     Madhuparna
> 
>     -Denny
> 

I've got a patch going through internal discussion and testing for 
adding rcu read locking.

The RDMAVT patch, I was OK with going in, I guess I just mentioned that 
in a reply rather than adding an RB tag. Let me go ahead and do that.

-Denny
