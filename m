From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Thu, 22 Oct 2009 10:47:17 -0600
Message-ID: <20091022164717.GG26003@obsidianresearch.com>
References: <1256164230.12075.31.camel@wilder.ibm.com> <9D257695083141E79685CB2B260D7D7C@amr.corp.intel.com> <20091021233639.GS14520@obsidianresearch.com> <BFF5CD71FFA74BF09A2EED5F3319F370@amr.corp.intel.com> <20091022002846.GU14520@obsidianresearch.com> <4803112A5B7A4953B62ABAFD1BBD9881@amr.corp.intel.com> <20091022011939.GW14520@obsidianresearch.com> <60E9443821EE4FFA90448DF5CC1368A8@amr.corp.intel.com> <20091022062531.GB26003@obsidianresearch.com> <B1D32A650C2F400E92AFC4909D8880A0@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <B1D32A650C2F400E92AFC4909D8880A0-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2009 at 11:49:52PM -0700, Sean Hefty wrote:
> >   This is actually something of a mandatory notion to implement the
> >   full generality of the IB CM protocol which allows the CM REP to
> >   contain a port GUID of another port on the same node (multi-port
> >   APM is an IB feature). So you never know what port the accept()
> >   result will get bound to.
> 
> You can redirect (REJ) a REQ to a different port, but you can't accept (REP) a
> connection on a different port.

Do you have a compliance statment for that? :)

Spec says:
 
 The initiator is responsible for proposing the Port Addresses
 (Primary and optional Alternate) that the target (REQ recipient) is to
 use for the channel.  Based on the path defined by those port
 addresses, the initiator provides timeout information and the Service
 Level to be used by the target for any messages that it initiates. The
 SL from initiator to target need not be the same as from target to
 initiator, but the SL that is contained within the REQ message is the
 one that the initiator would prefer the target use. Path in- formation
 is available from Subnet Administration (see section 15.2.5.16
 PathRecord).

'Proposing the Port Addresses' == Any Port On the Node, IMHO.

Someone went to alot of trouble to include enough unnecessary
information to make that possible, and it is necessary for multi port
APM.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
