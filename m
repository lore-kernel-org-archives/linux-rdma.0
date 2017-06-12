From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 15:57:29 -0500
Message-ID: <085201d2e3be$81070ce0$831526a0$@opengridcomputing.com>
References: <20170612064918.12510-1-leon@kernel.org> <074a01d2e39f$edc28860$c9479920$@opengridcomputing.com> <VI1PR0502MB3008CE85A4F274886B74DF2BD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com> <3fa7a4b5-5c19-8c6a-d78b-93219a9be888@intel.com> <1828884A29C6694DAF28B7E6B8A82373AB142A9B@ORSMSX109.amr.corp.intel.com> <VI1PR0502MB300885A1DD676E1649CDB268D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com> <b5279c09-027f-e374-ffde-7f236c52322c@intel.com> <1828884A29C6694DAF28B7E6B8A82373AB142BEC@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB142BEC-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'Dalessandro, Dennis'" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Parav Pandit' <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Idan Burstein' <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > When transmitter and receiver is enabled to do so, as I described in
> > overview section of Documentation, it helps
> > > (a) to avoid retransmission - improves network utilization
> > > (b) reduces latency due to timers not kicking in.
> >
> > Yes those benefits are clear. I see no reason why it shouldn't always
> > be
> > done is my point. Application shouldn't have to care and there is no
> > need to make this an additional flag.
> 
> The app cares when data from write 2 can be written at the target before data
> from write 1, especially if the writes target the same memory buffers.  (At least I
> think this is the intent of exposing this to the app.)
> 
> Note that the provider can always provide stronger ordering than what the app
> needs.

My understanding is that IB or IW apps should never assume ingress write or read response data is _placed_ into local memory in the order it was transmitted from the peer.  The only guarantee is that the _indication_ of the arrived data preserve the sender's ordering.  However, I'm thinking that there are applications out there that spin polling local memory that is the target of a write or read response and assume the last bit of that memory will get written last...

 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
