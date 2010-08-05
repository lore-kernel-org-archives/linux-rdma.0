From: "Suresh Shelvapille" <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Subject: RE: How to know if SRQ is being used in SRP?
Date: Thu, 5 Aug 2010 14:05:56 -0400
Message-ID: <D8F95421ED674F1DAC3A9A471854A748@md.baymicrosystems.com>
References: <201008031602.37294.bvanassche@acm.org> <4C59C34F.2000400@vlnb.net><adak4o66rir.fsf@roland-alpha.cisco.com> <AANLkTikswdOfqoZOmSqmug4ue3KLv3V8NH9W1ME4tnfQ@mail.gmail.com> <8BAAFD34FEF6492A8E3B43698E454B3D@md.baymicrosystems.com> <1281030129.7414.16.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1281030129.7414.16.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Ralph Campbell' <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ralph:
I am told that the customer has modified the SRP code, which is why I cannot go by the ib_srp.c code. 
Hence, I am trying to figure out from the IB transport traces whether SRQ is being used or not. 
1. Would the Syndrome field show CC INVALID if SRQ were being used? If so, in which IB message would it show---RDMA read
response, or in an initial RC SEND message or both?

Thanks,
Suri 


> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Ralph
> Campbell
> Sent: Thursday, August 05, 2010 1:42 PM
> To: Suresh Shelvapille
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: How to know if SRQ is being used in SRP?
> 
> SRP doesn't use a SRQ.
> 
> Look at drivers/infiniband/ulp/srp/ib_srp.c for
> ib_create_qp() and the init_attr.cap.max_recv_wr is set
> and init_attr.ib_srq is not set.
> 
> On Thu, 2010-08-05 at 09:38 -0700, Suresh Shelvapille wrote:
> > Folks:
> >
> > I have the envious task of figuring out whether SRQ is being used in an SRP application (which I
> have very little
> > knowledge about). I only have IB transport layer traces from the customer.
> > From the traces I can see Valid Credits in the Syndrome field of the AETH in
> RDMA_ReadResponse_First/last messages.
> > Although there are a bunch of RC SENDs where the AETH syndrome field is Invalid, unfortunately I
> cannot seem to
> > correlate these RC SENDS with the RDMA read/responses.
> > My questions is, since the RDMA response AETH field has valid CC credits is it saying SRQ is not
> being used?
> >
> > Many thanks,
> > Suri
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
