From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: Default force_link_speed value in opensm configuration
Date: Mon, 12 Oct 2009 14:35:53 -0700
Message-ID: <20091012143553.04554689.weiny2@llnl.gov>
References: <4ACB6891.7010202@gmail.com>
	<20091006142728.3d1e5bcc.weiny2@llnl.gov>
	<4AD2FB39.6040602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD2FB39.6040602-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 12 Oct 2009 11:47:37 +0200
"Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Ira Weiny wrote:
> > On Tue, 06 Oct 2009 17:56:01 +0200
> > "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > 
> >> Hi,
> >>
> >> Is there a reason for setting default force_link_speed to 15 (set enabled as supported) 
> >> and not to 0 (don't modify PortInfo:LinkSpeedEnabled )?
> > 
> > The thought was to enable all ports to the maximum supported by default.  This
> > was the behavior before this option was added so it was though to leave it
> > alone by default.
> > 
> > Is there a reason this should not happen?  I guess since the Volume 2 spec
> > says that the power on default for this is LinkSpeedSupported there is no
> > reason to have the SM send these Set's.  Perhaps there is broken hardware out
> > there?
> 
> well actually there is a hardware that supports only 5.0Gbps (but reports 2.5 or 5.0 Gbps since there is no option for 5.0 only)
> and powers on with enabled speed of 5.0Gbps only.
> Setting the enabled speed to the supported speed will fail further negotiation (after link reset) since the device does not support 2.5Gbps.

That seems like broken hardware...

> 
> So if the default for all other devices is enabled=supported then we can change the opensm configuration force_link_speed to 0.
>

I have no problem changing it.  As I said if hardware is compliant I think it
might speed things up.  I will test out a patch with the hardware I can test.

However, I would like to know if anyone else knows of hardware which needs it
set to "15".  If so, this is going to be an interesting problem...  ;-)

Ira


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
