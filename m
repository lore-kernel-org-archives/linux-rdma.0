From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv2] libibmad: Add new fields for SM:PortInfoExtended and
 for PM:PortExtendedSpeedsCounters
Date: Sun, 09 Nov 2014 01:33:02 -0500
Message-ID: <545F0A9E.6080904@dev.mellanox.co.il>
References: <20141023062532.GA31987@r-ufm96.mtr.labs.mlnx> <2807E5FD2F6FDA4886F6618EAC48510E0CBA7D00@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CBA7D00-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/8/2014 9:29 AM, Weiny, Ira wrote:
>> --- a/src/fields.c
>> > +++ b/src/fields.c
>> > @@ -949,8 +949,42 @@ static const ib_field_t ib_mad_f[] = {
>> >  	{480, 32, "Counter14", mad_dump_uint},
>> >  	{0, 0},			/* IB_PSR_LAST_F */
>> > 
>> > -	{0, 0}			/* IB_FIELD_LAST_ */
>> > +	/*
>> > +	 * PortInfoExtended fields
>> > +	 */
>> > +	{0, 32, "CapMask", mad_dump_hex},
> I'm not quite sure why the spec was written this way but technically CapMask is only 1 bit???

PortInfoExtended:CapMask is 32 bit field. Current 1.3 draft is
misformatted. The two rows are supposed to be combined into 1 and things
are misaligned. IsFECModeSupported is 1 bit (first bit out of those 32
bits).

> Therefore I'm not sure we can define this field as above.  Can we get some assurances from the management WG 
> that the 31 bit reserved field following the CapMask are only going to extend the CapMask?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
