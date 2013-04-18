From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libibmad: To fix big endian problem for both 32-bit &
 64-bit SPARC
Date: Thu, 18 Apr 2013 17:52:42 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E01595D5A@CRSMSX102.amr.corp.intel.com>
References: <513F83BD.3050302@oracle.com>
 <5140759D.1030500@dev.mellanox.co.il> <514077DB.9000703@mellanox.com>
 <5141FAFD.5070109@oracle.com> <516FCAE6.3010403@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <516FCAE6.3010403-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'll reject the patch.  Thanks for getting back to me.

Ira

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Pramod Gunjikar
> Sent: Thursday, April 18, 2013 3:29 AM
> To: Boris Chiu
> Cc: Or Gerlitz; Hal Rosenstock; Ira Weiny; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] libibmad: To fix big endian problem for both 32-bit & 64-
> bit SPARC
> 
> Hello Hal / Or,
> 
> Sorry for the delay in getting back on this.
> 
>   Solaris specific endian fixes were  applied to OFED 1.3 in order to fix
> infiniband-diag failures observed
>   on SPARC. Changes to OFED 1.5.3 now make these fixes redundant
> consequently the patch request
>   is withdrawn.
> 
> Let us know if you have any queries.
> 
> Thanks
>     Pramod
> 
> > Hi Hal and Or,
> >
> > We are checking on this and will get back.
> >
> > Thanks,
> > Boris
> >
> > On 03/13/13 05:58, Or Gerlitz wrote:
> >> On 13/03/2013 14:48, Hal Rosenstock wrote:
> >>> On 3/12/2013 3:36 PM, Boris Chiu wrote:
> >>>> >--- a/src/dump.c
> >>>> >+++ b/src/dump.c
> >>>> >@@ -46,12 +46,24 @@
> >>>> >
> >>>> >void mad_dump_int(char *buf, int bufsz, void *val, int valsz) {
> >>>> >+    /*
> >>>> >+     * the val pointer passed to the dump routines are always 32 bit
> >>>> >+     * integers for valsz <= 4 and 64 bit integer for the rest.
> >>>> It is
> >>>> >never
> >>>> >+     * uint8_t or uint16_t. This is because mad_decode_field
> >>>> >+ always
> >>>> >returns
> >>>> >+     * the values as 32 bit integer even if they are 8 bit or 16
> >>>> >+ bit
> >>>> >fields.
> >>>> >+     */
> >>>> >     switch (valsz) {
> >>>> >     case 1:
> >>>> >-        snprintf(buf, bufsz, "%d", *(uint32_t *) val & 0xff);
> >>>> >+#if defined(_BIG_ENDIAN)
> >>>> >+        val = ((uint8_t *)val) + 3; #endif /* _BIG_ENDIAN */
> >>> I don't understand what's different about SPARC and PPC in terms of
> >>> this. These routines all work without this on PPC64 and PPC32.
> >>
> >> Yep, agree, assuming the code works on other BE archs, we 1st and
> >> most need to understand the problem before going to solutions.
> >>
> >> Or.
> >>
> >>
> >>
> >>>
> >>> At a minimum, should this be ifdef'd on something like both __sun
> >>> and
> >>> __SVR4 rather than _BIG_ENDIAN ?
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
