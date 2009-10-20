From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 20 Oct 2009 12:13:03 -0700
Message-ID: <A47D2FC6B143436DB87704307B0E715D@amr.corp.intel.com>
References: <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com> <4ACAF913.3050909@voltaire.com> <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com> <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com> <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com> <15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com> <859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com> <4ADD8F5F.3010008@voltaire.com> <9F76F7CD7B9048E8821A1B05CC5FAFE8@amr.corp.intel.com> <20091020183132.GE14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091020183132.GE14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> rdma_bind_addr fills in the service id according RDMA IP CM service
>> annex.
>
>Hm? If the sockaddr_ib contains the service ID why override it in the
>kernel?
>
>The AF_IB/PS_IB flow in the kernel side must just use straight service
>IDs.

I agree.  But we can still support AF_IB/PS_TCP by simply assigning the service
ID correctly.  rdma_bind_addr only needs to fill in a service id if one is not
given.  This should enable interoperability.  I realize that IB doesn't have the
concept of a service ID for the active side of a connection, but the RDMA IP CM
Service header carries the source port.  And rdma_bind_addr is called by
rdma_resolve_addr, so it needs to be updated. 

Even once PS_IB is added, we need to make sure that it doesn't collide with
PS_TCP at the IB service ID level, or IB will be in the same situation that
iWarp is in with space collisions.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
