From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: OpenSM 3.3.16 at 100% CPU load, "console off"
Date: Wed, 09 Oct 2013 15:53:29 +0200
Message-ID: <52555FD9.5030805@profitbricks.com>
References: <525539A4.8090700@profitbricks.com>  <52555A04.8080606@dev.mellanox.co.il> <1381325445.27365.4.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381325445.27365.4.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09.10.2013 15:30, David Dillow wrote:
> On Wed, 2013-10-09 at 09:28 -0400, Hal Rosenstock wrote:
>>> >From strace:
>>> poll([{fd=0, events=POLLIN}], 1, 1000)  = 1 ([{fd=0, revents=POLLIN}])
>>> read(0, "", 4096)                       = 0
>>> poll([{fd=0, events=POLLIN}], 1, 1000)  = 1 ([{fd=0, revents=POLLIN}])
>>> read(0, "", 4096)                       = 0
>>> poll([{fd=0, events=POLLIN}], 1, 1000)  = 1 ([{fd=0, revents=POLLIN}])
>>> read(0, "", 4096)                       = 0
>>
>> So this doesn't block for 1 second and that's why the CPU is 100% ?
> 
> Looks like it is spinning on a closed socket (or stdin) -- calling
> poll() on such will return immediately...
> 

Thanks for the responses!

I've seen in the code that the local console is initialized but is not
released correctly. Should be done in osm_console_exit().

Something like this:

       if (p_oct->in_fd >= 0) {
               p_oct->in = NULL;
               p_oct->out = NULL;
               p_oct->in_fd = -1;
               p_oct->out_fd = -1;
       }

I guess what happened was that "console local" was set, changed in the
config to "console off" and the service has been restarted. Restarting
the service again didn't help.

It is strange that the console_init_flag is still set. The function
osm_console() returns 0 if poll() fails. If it would return something
else, then the console_init_flag would be set to 0 again and there would
be no issue anymore I suppose.

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
