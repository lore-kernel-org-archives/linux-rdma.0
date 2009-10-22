From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] link-local address fix for rdma_resolve_addr
Date: Thu, 22 Oct 2009 11:31:07 -0700
Message-ID: <60293EE44E7243B59C41498F20D558A0@amr.corp.intel.com>
References: <20091021233639.GS14520@obsidianresearch.com> <BFF5CD71FFA74BF09A2EED5F3319F370@amr.corp.intel.com> <20091022002846.GU14520@obsidianresearch.com> <4803112A5B7A4953B62ABAFD1BBD9881@amr.corp.intel.com> <20091022011939.GW14520@obsidianresearch.com> <60E9443821EE4FFA90448DF5CC1368A8@amr.corp.intel.com> <20091022062531.GB26003@obsidianresearch.com> <B1D32A650C2F400E92AFC4909D8880A0@amr.corp.intel.com> <20091022164717.GG26003@obsidianresearch.com> <A03920DE5BAE4309BAFC1B6471AE928C@amr.corp.intel.com> <20091022182221.GZ14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091022182221.GZ14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Why would it need to? The REQ contains all the port information
>necessary, the active side doesn't get to pick the port, it just gets
>to approve it.

I'm not following you at all now.  You said:

This is actually something of a mandatory notion to implement the
full generality of the IB CM protocol which allows the CM REP to
contain a port GUID of another port on the same node (multi-port
APM is an IB feature). So you never know what port the accept()
result will get bound to.

The REP does not contain a port GUID, so what exactly were you trying to say
here?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
