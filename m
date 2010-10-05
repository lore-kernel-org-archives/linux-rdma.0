From: Bernard Metzler <BMT@zurich.ibm.com>
Subject: Re: [PATCH] SIW: iWARP Protocol headers
Date: Tue, 5 Oct 2010 18:06:09 +0200
Message-ID: <OF381378D0.1649122C-ONC12577B3.0058222E-C12577B3.00587475@ch.ibm.com>
References: <1286261630-5085-1-git-send-email-bmt@zurich.ibm.com> <4CAB2DDA.1020207@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4CAB2DDA.1020207@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: linux-rdma@vger.kernel.org, linux-rdma-owner@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

<snip>
> > + */
> > +struct iwarp_ctrl_tagged {
> > +   struct iwarp_ctrl   ctrl;
> > +   __u32         ddp_stag;
> > +   __u64         ddp_to;
> > +} __attribute__((__packed__));
> > +
> > 
> 
> All of the above header structures should use __beXX types since the 
> fields are all in Network Byte Order.
> 
right. will get fixed.

> Also, did you run sparse on the patches (Documentation/sparse.txt)?
> 
> 
frankly, i was not aware. sorry. will do.

bernard.
