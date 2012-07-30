From: "Foraker, Jim" <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 5/8] opensm: Signal subnet init errors on SubnGet
 timeouts
Date: Mon, 30 Jul 2012 10:19:36 -0700
Message-ID: <CC3C0DAE.1C57%foraker1@llnl.gov>
References: <20120729162933.GE5195@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120729162933.GE5195@calypso>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/29/12 9:29 AM, "Alex Netes" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

>Hi Jim,
>
>On 15:19 Mon 23 Jul     , Jim Foraker wrote:
>> 
>> On Mon, 2012-07-23 at 08:43 -0700, Alex Netes wrote:
>> > Hi Jim,
>> > 
>> > On 17:55 Mon 25 Jun     , Jim Foraker wrote:
>> > > A subnet should not be listed as cleanly initialized if CAs
>> > > fail to respond to SubnGet requests.
>> > > 
>> > > Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
>> > > ---
>> > >  opensm/osm_sm_mad_ctrl.c |    9 +++++++++
>> > >  1 file changed, 9 insertions(+)
>> > > 
>> > > diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
>> > > index f0bcff2..464b6b0 100644
>> > > --- a/opensm/osm_sm_mad_ctrl.c
>> > > +++ b/opensm/osm_sm_mad_ctrl.c
>> > > @@ -741,6 +741,15 @@ static void sm_mad_ctrl_send_err_cb(IN void
>>*context, IN osm_madw_t * p_madw)
>> > >  			cl_ntoh16(p_smp->attr_id),
>> > >  			ib_get_sm_attr_str(p_smp->attr_id));
>> > >  		p_ctrl->p_subn->subnet_initialization_error = TRUE;
>> > > +	} else if (p_madw->status == IB_TIMEOUT &&
>> > > +		   p_smp->method == IB_MAD_METHOD_GET) {
>> > 
>> > It's pretty common to see timeouts in fabrics without m_key support
>>(e.g.
>> > switch reboots) and it's not desirable to start another heavy sweep
>>because
>> > of that. So I guess it would be better if we could initiate heavy
>>sweep only
>> > when m_key is set and protection level is 2 or 3.
>>      This was done primarily to ensure that "SUBNET UP" doesn't get
>> displayed/logged while there are unconfigured HCAs due to misset mkeys.
>> I'm reasonably sure (I will re-test to verify) that future light sweeps
>> will catch HCAs whos mkeys timeout, presuming the timeout is set.  So we
>> could also just log the error and not worry about setting
>> subnet_initialization_error.
>
>It's fine to have TIMEOUTs on Get() in case we are dealing with M_Key
>set, but
>in general case we don't want to run into heavy sweep loops because of
>TIMEOUTs on Get(), so I suggest the following:
>
>+       } else if (p_ctrl->p_subn->opt.m_key &&
>+                  p_ctrl->p_subn->opt.m_key_protect_bits > 1 &&
>+                  p_madw->status == IB_TIMEOUT &&
>+                  p_smp->method == IB_MAD_METHOD_GET) {
>+               /* Timeouts on SubnGet may be an indication of an mkey
>+                  error at protection levels 2/3 */
>+               OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3120 "
>+                       "Timeout while getting attribute 0x%X (%s)\n",
>+                       cl_ntoh16(p_smp->attr_id),
>+                       ib_get_sm_attr_str(p_smp->attr_id));
>+               p_ctrl->p_subn->subnet_initialization_error = TRUE;
>
>
>-- Alex
>

     At the moment, what I have instead is:

+ 	} else if (p_madw->status == IB_TIMEOUT &&
+ 		   p_smp->method == IB_MAD_METHOD_GET) {
+		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3120 "
+ 			"Timeout while getting attribute 0x%X (%s); "
+ 			"Possible mis-set mkey?\n",
+ 		cl_ntoh16(p_smp->attr_id),
+ 		ib_get_sm_attr_str(p_smp->attr_id));

IE, we do not set the initialization error flag, but we always log the
error.  I like always reporting the error, because it better catches the
case where the CA's mkey/protect bits don't match what the SM expects.


     Jim

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
