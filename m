From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: Default force_link_speed value in opensm configuration
Date: Tue, 6 Oct 2009 14:27:28 -0700
Message-ID: <20091006142728.3d1e5bcc.weiny2@llnl.gov>
References: <4ACB6891.7010202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ACB6891.7010202-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 06 Oct 2009 17:56:01 +0200
"Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi,
> 
> Is there a reason for setting default force_link_speed to 15 (set enabled as supported) 
> and not to 0 (don't modify PortInfo:LinkSpeedEnabled )?

The thought was to enable all ports to the maximum supported by default.  This
was the behavior before this option was added so it was though to leave it
alone by default.

Is there a reason this should not happen?  I guess since the Volume 2 spec
says that the power on default for this is LinkSpeedSupported there is no
reason to have the SM send these Set's.  Perhaps there is broken hardware out
there?

Ira


> 
> Thanks,
> Eli
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://*vger.kernel.org/majordomo-info.html
> 


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
