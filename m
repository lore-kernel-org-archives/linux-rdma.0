From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCHv2] libibmad: Add new fields for SM:PortInfoExtended and
 for PM:PortExtendedSpeedsCounters
Date: Sun, 9 Nov 2014 22:48:47 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CBA8F2F@CRSMSX101.amr.corp.intel.com>
References: <20141023062532.GA31987@r-ufm96.mtr.labs.mlnx>
 <2807E5FD2F6FDA4886F6618EAC48510E0CBA7D00@CRSMSX101.amr.corp.intel.com>
 <545F0A9E.6080904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <545F0A9E.6080904-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On 11/8/2014 9:29 AM, Weiny, Ira wrote:
> >> --- a/src/fields.c
> >> > +++ b/src/fields.c
> >> > @@ -949,8 +949,42 @@ static const ib_field_t ib_mad_f[] = {
> >> >  	{480, 32, "Counter14", mad_dump_uint},
> >> >  	{0, 0},			/* IB_PSR_LAST_F */
> >> >
> >> > -	{0, 0}			/* IB_FIELD_LAST_ */
> >> > +	/*
> >> > +	 * PortInfoExtended fields
> >> > +	 */
> >> > +	{0, 32, "CapMask", mad_dump_hex},
> > I'm not quite sure why the spec was written this way but technically CapMask
> is only 1 bit???
> 
> PortInfoExtended:CapMask is 32 bit field. Current 1.3 draft is misformatted.

Thanks...  That makes more sense.  Sorry I only just got access to the new 1.3 draft.

-- Ira

> The two rows are supposed to be combined into 1 and things are misaligned.
> IsFECModeSupported is 1 bit (first bit out of those 32 bits).
> 
> > Therefore I'm not sure we can define this field as above.  Can we get
> > some assurances from the management WG that the 31 bit reserved field
> following the CapMask are only going to extend the CapMask?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
