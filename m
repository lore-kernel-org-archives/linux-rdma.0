From: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: RDMAoE verbs questions
Date: Mon, 30 Nov 2009 14:01:45 -0600
Message-ID: <5AEC2602AE03EB46BFC16C6B9B200DA81691763FEA@MNEXMB2.qlogic.org>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>
	<20091125001136.GP6188@obsidianresearch.com>	<20091130133406.GA32123@mtls03>
 <adaiqcrx2xx.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaiqcrx2xx.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  > diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
>  > index 07d4395..f7fe68d 100644
>  > --- a/include/infiniband/verbs.h
>  > +++ b/include/infiniband/verbs.h
>  > @@ -192,7 +192,7 @@ struct ibv_port_attr {
>  >         uint8_t                 active_width;
>  >         uint8_t                 active_speed;
>  >         uint8_t                 phys_state;
>  > -       enum rdma_transport_type transport;
>  > +       uint8_t                 transport;

If a given architecture rounds sizeof(transport) up to 16 bits or 32 bits, then the replacement field should be uint16_t or uint32_t respectively, otherwise existing binary applications which fetch transport will fetch additional undefined bytes which follow it in the new structure.

The big question is whether all presently supported architectures use the same size for enum?

I did a quicky test program and on SLES10 x86_64 sizeof(an enum) is 32 bits.  Hence uint8_t would break binary compatibility on that platform.

Todd Rimmer

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
