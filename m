From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 20 Oct 2009 13:05:15 -0700
Message-ID: <8D09997BDBC5482C86EAD338F19C8030@amr.corp.intel.com>
References: <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com> <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com> <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com> <15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com> <859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com> <4ADD8F5F.3010008@voltaire.com> <9F76F7CD7B9048E8821A1B05CC5FAFE8@amr.corp.intel.com> <20091020183132.GE14520@obsidianresearch.com> <A47D2FC6B143436DB87704307B0E715D@amr.corp.intel.com> <20091020191821.GI14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091020191821.GI14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> I agree.  But we can still support AF_IB/PS_TCP by simply assigning
>> the service ID correctly.  rdma_bind_addr only needs to fill in a
>> service id if one is not given.  This should enable
>
>'one is not given' == 0 service ID?

yes

I'm guessing PS_IB would need to assign from the IB CM assigned range starting
at 0x020::0 to avoid conflicts.

>Is there any reason to ever use AF_IB/PS_TCP on the listening side?

I don't think so.  I was thinking of this combination on the active side in
order to get the port number to place in the private data.

>What functional difference are you imagining compared to listening on
>AF_INET/PS_TCP?

I hadn't thought about this, but making stuff up, I guess this could allow using
the rdma_cm without ipoib running...?  From IB's perspective, PS_TCP is just a
specific subset of the service ID range.

>> Even once PS_IB is added, we need to make sure that it doesn't collide with
>> PS_TCP at the IB service ID level, or IB will be in the same situation that
>> iWarp is in with space collisions.
>
>I thought there was already a single service ID registration list that was
>shared between RDMA CM and IB CM?

Not really - the rdma cm constructs the service id, and the ib cm checks that
it's usable, but not until listen is called.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
