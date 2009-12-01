From: Jeff Roberson <jroberson-gUAg20sWgfgcWVvVuXF20w@public.gmane.org>
Subject: RE: LID reconfiguration
Date: Mon, 30 Nov 2009 14:28:22 -1000 (HST)
Message-ID: <alpine.BSF.2.00.0911301407180.1226@desktop>
References: <alpine.BSF.2.00.0911091324150.1226@desktop> <20091109234547.GH6188@obsidianresearch.com> <alpine.BSF.2.00.0911091348360.1226@desktop> <20091110002047.GJ6188@obsidianresearch.com> <alpine.BSF.2.00.0911161835230.1226@desktop>
 <6A30FB8CEED94D778E7CDAE4660458DA@amr.corp.intel.com> <alpine.BSF.2.00.0911231745350.1226@desktop> <10477AA8CF094F2F92E8792307982F66@amr.corp.intel.com> <alpine.BSF.2.00.0911240951000.1226@desktop> <65B503E4F968463B8D6D5D019E036ED7@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <65B503E4F968463B8D6D5D019E036ED7-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 24 Nov 2009, Sean Hefty wrote:

>> That's what I suspected.  I wonder if the connection state isn't set
>> properly until later?  I'm really not sure.  Without a kernel debugger
>> it'll be hard to determine.  I guess I can throw some printfs in to track
>> this down unless there are better suggestions.
>
> Adding some printk's to ib_send_cm_lap() may be sufficient.  I would look at the
> cm_id state (should be IB_CM_ESTABLISHED) and the lap_state (should be
> IB_CM_LAP_UNINT the first time it's called).
>
> - Sean
>

I think I have tracked down part of my problem.  So just quickly to recap, 
what I'm trying to do is as send a lap immediately after sending the rtu. 
This fails on the server side when the server receives the RTU and tries 
to modify the qp to RTS.  I enabled mthca debugging and discovered that 
the qp attr isn't being setup properly.  I then found code in 
cm_init_qp_rts_attr that looks suspicious:

         if (cm_id_priv->id.lap_state == IB_CM_LAP_UNINIT) {
         } else {
             *qp_attr_mask = IB_QP_ALT_PATH | IB_QP_PATH_MIG_STATE;

So what happens is we don't actually do the RTR->RTS transition if lap is 
not 'uninit'.  I don't know if the stack peeks ahead and sees the lap 
message before userland processes the rtu.

In any event, it's invalid to do RTR->RTR and this prevents the RTR->RTS 
transition from ever happening.  If I skip this check the first transition 
works as expected but I suspect subsequent lap updates will not.

Really it looks as if this check should be predicated on the actual QP 
state which we don't seem to have at this time.  The CM state also doesn't 
seem to be useful as it is already ESTABLISHED in this case.

Any suggestions?

Thanks,
Jeff

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
