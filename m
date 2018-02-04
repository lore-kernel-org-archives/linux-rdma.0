From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Request for Comments on SoftiWarp
Date: Sun, 4 Feb 2018 20:08:31 +0000
Message-ID: <OFEF72EEE6.7E5C3FA5-ON0025822A.005B18E4-0025822A.006EA4BB@notes.na.collabserv.com>
References: <20180202185640.GC9080@ziepe.ca>,<031f01d38fad$422520c0$c66f6240$@opengridcomputing.com>
 <20180114223603.19961-1-bmt@zurich.ibm.com>
 <OFD1018BEE.35589194-ON00258228.00505F2B-00258228.00505F31@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180202185640.GC9080-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



-----Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote: -----

>To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
>Date: 02/02/2018 07:57PM
>Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>,
>linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v3 00/13] Request for Comments on SoftiWarp
>
>On Fri, Feb 02, 2018 at 02:37:52PM +0000, Bernard Metzler wrote:
>
>> I added libsiw to the current (as of today) rmda-core bundle
>> as found at
>https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_linux
>-2Drdma_rdma-2Dcore.git&d=DwIBAg&c=jf_iaSHvJObTbx-siA1ZOg&r=2TaYXQ0T-
>r8ZO1PP1alNwU_QJcRRLfmYTAgd3QCvqSc&m=UyHYNdR3HpzdZu5UEC-C3m-y2oY_mSux
>ocEezYKO-Sw&s=_1Odt9orPiTCNcrPz9U1gEwckeRc4RoeUwPsvPogtCI&e=, see
>
>Can you use the standard OFA license please? IBM is an OFA member and
>is behloden to the membership agreement requring the common dual
>license.
>

sorry to see that. What's exactly wrong with the current (dual) license 
statement from IBM? I checked several other user libs. All come with
some flavor of a dual BSD/GPLv2 license statement as this one,
as far as I can see.

>> It enables user level clients for the siw driver. Let me
>> know if we need a patch for user land as well for now.
>> I don't want to spam the list.
>
>We will eventually..
>
>+static const struct verbs_match_ent rnic_table[] = {
>+	VERBS_NAME_MATCH("siw", NULL),
>+	{},
>+};
>
>I really don't want to add more VERBS_NAME_MATCH, but I don't have an
>alternative ready right now :(
>

Hmm, I blindly followed what others did. This is different from
what libsiw had until now (doing its own sys entries reading/pattern
matching). I hope I did it right?
In any case, I hope this current approach allows for co-existence
of user libs from different vendors if heterogeneous hardware is
in use.

Thanks very much!
Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
