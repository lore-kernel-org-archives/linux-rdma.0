From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libibmad: To fix big endian problem for both 32-bit &
 64-bit SPARC
Date: Wed, 13 Mar 2013 16:28:28 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510EBB3193@CRSMSX102.amr.corp.intel.com>
References: <513F83BD.3050302@oracle.com>
 <5140759D.1030500@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5140759D.1030500-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hal Rosenstock
> Sent: Wednesday, March 13, 2013 8:48 AM
> To: Boris Chiu
> Cc: Ira Weiny; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] libibmad: To fix big endian problem for both 32-bit & 64-
> bit SPARC
> 
> On 3/12/2013 3:36 PM, Boris Chiu wrote:
> > From: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >
> > Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> > src/dump.c |   66
> > +++++++++++++++++++++++++++++++++++++++++++++++++++--------
> > 1 files changed, 57 insertions(+), 9 deletions(-)
> >
> > diff --git a/src/dump.c b/src/dump.c
> > index 7f3ef7d..e83c363 100644
> > --- a/src/dump.c
> > +++ b/src/dump.c
> > @@ -46,12 +46,24 @@
> >
> > void mad_dump_int(char *buf, int bufsz, void *val, int valsz) {
> > +    /*
> > +     * the val pointer passed to the dump routines are always 32 bit
> > +     * integers for valsz <= 4 and 64 bit integer for the rest. It is
> > never
> > +     * uint8_t or uint16_t. This is because mad_decode_field always
> > returns
> > +     * the values as 32 bit integer even if they are 8 bit or 16 bit
> > fields.
> > +     */
> >     switch (valsz) {
> >     case 1:
> > -        snprintf(buf, bufsz, "%d", *(uint32_t *) val & 0xff);
> > +#if defined(_BIG_ENDIAN)
> > +        val = ((uint8_t *)val) + 3;
> > +#endif /* _BIG_ENDIAN */
> 
> I don't understand what's different about SPARC and PPC in terms of this.
> These routines all work without this on PPC64 and PPC32.
> 
> At a minimum, should this be ifdef'd on something like both __sun and
> __SVR4 rather than _BIG_ENDIAN ?

Are you perhaps calling these with Network Byte order values?  While not documented they are designed to take values in host byte order which as Hal states should work on all big and little endian architectures.

Ira


> 
> -- Hal
> 
> > +        snprintf(buf, bufsz, "%d", *(uint8_t *) val & 0xff);
> >         break;
> >     case 2:
> > -        snprintf(buf, bufsz, "%d", *(uint32_t *) val & 0xffff);
> > +#if defined(_BIG_ENDIAN)
> > +        val = ((uint16_t *)val) + 1;
> > +#endif /* _BIG_ENDIAN */
> > +        snprintf(buf, bufsz, "%d", *(uint16_t *) val & 0xffff);
> >         break;
> >     case 3:
> >     case 4:
> > @@ -71,12 +83,24 @@ void mad_dump_int(char *buf, int bufsz, void *val,
> > int valsz)
> >
> > void mad_dump_uint(char *buf, int bufsz, void *val, int valsz) {
> > +    /*
> > +     * the val pointer passed to the dump routines are always 32 bit
> > +     * integers for valsz <= 4 and 64 bit integer for the rest. It is
> > never
> > +     * uint8_t or uint16_t. This is because mad_decode_field always
> > returns
> > +     * the values as 32 bit integer even if they are 8 bit or 16 bit
> > fields.
> > +     */
> >     switch (valsz) {
> >     case 1:
> > -        snprintf(buf, bufsz, "%u", *(uint32_t *) val & 0xff);
> > +#if defined(_BIG_ENDIAN)
> > +        val = ((uint8_t *)val) + 3;
> > +#endif /* _BIG_ENDIAN */
> > +        snprintf(buf, bufsz, "%u", *(uint8_t *) val & 0xff);
> >         break;
> >     case 2:
> > -        snprintf(buf, bufsz, "%u", *(uint32_t *) val & 0xffff);
> > +#if defined(_BIG_ENDIAN)
> > +        val = ((uint16_t *)val) + 1;
> > +#endif /* _BIG_ENDIAN */
> > +        snprintf(buf, bufsz, "%u", *(uint16_t *) val & 0xffff);
> >         break;
> >     case 3:
> >     case 4:
> > @@ -96,15 +120,27 @@ void mad_dump_uint(char *buf, int bufsz, void
> > *val, int valsz)
> >
> > void mad_dump_hex(char *buf, int bufsz, void *val, int valsz) {
> > +    /*
> > +     * the val pointer passed to the dump routines are always 32 bit
> > +     * integers for valsz <= 4 and 64 bit integer for the rest. It is
> > never
> > +     * uint8_t or uint16_t. This is because mad_decode_field always
> > returns
> > +     * the values as 32 bit integer even if they are 8 bit or 16 bit
> > fields.
> > +     */
> >     switch (valsz) {
> >     case 1:
> > -        snprintf(buf, bufsz, "0x%02x", *(uint32_t *) val & 0xff);
> > +#if defined(_BIG_ENDIAN)
> > +        val = ((uint8_t *)val) + 3;
> > +#endif /* _BIG_ENDIAN */
> > +        snprintf(buf, bufsz, "0x%02x", *(uint8_t *) val & 0xff);
> >         break;
> >     case 2:
> > -        snprintf(buf, bufsz, "0x%04x", *(uint32_t *) val & 0xffff);
> > +#if defined(_BIG_ENDIAN)
> > +        val = ((uint16_t *)val) + 1;
> > +#endif /* _BIG_ENDIAN */
> > +        snprintf(buf, bufsz, "0x%04x", *(uint16_t *) val & 0xffff);
> >         break;
> >     case 3:
> > -        snprintf(buf, bufsz, "0x%06x", *(uint32_t *) val & 0xffffff);
> > +        snprintf(buf, bufsz, "0x%x", *(uint32_t *) val & 0xffffff);
> >         break;
> >     case 4:
> >         snprintf(buf, bufsz, "0x%08x", *(uint32_t *) val); @@ -132,12
> > +168,24 @@ void mad_dump_hex(char *buf, int bufsz, void *val, int
> > valsz)
> >
> > void mad_dump_rhex(char *buf, int bufsz, void *val, int valsz) {
> > +    /*
> > +     * the val pointer passed to the dump routines are always 32 bit
> > +     * integers for valsz <= 4 and 64 bit integer for the rest. It is
> > never
> > +     * uint8_t or uint16_t. This is because mad_decode_field always
> > returns
> > +     * the values as 32 bit integer even if they are 8 bit or 16 bit
> > fields.
> > +     */
> >     switch (valsz) {
> >     case 1:
> > -        snprintf(buf, bufsz, "%02x", *(uint32_t *) val & 0xff);
> > +#if defined(_BIG_ENDIAN)
> > +        val = ((uint8_t *)val) + 3;
> > +#endif /* _BIG_ENDIAN */
> > +        snprintf(buf, bufsz, "%02x", *(uint8_t *) val & 0xff);
> >         break;
> >     case 2:
> > -        snprintf(buf, bufsz, "%04x", *(uint32_t *) val & 0xffff);
> > +#if defined(_BIG_ENDIAN)
> > +        val = ((uint16_t *)val) + 1;
> > +#endif /* _BIG_ENDIAN */
> > +        snprintf(buf, bufsz, "%04x", *(uint16_t *) val & 0xffff);
> >         break;
> >     case 3:
> >         snprintf(buf, bufsz, "%06x", *(uint32_t *) val & 0xffffff);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
