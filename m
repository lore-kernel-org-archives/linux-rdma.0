From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Infiniband SM - ConnectX driver stuck in INIT state
Date: Thu, 24 May 2012 10:51:25 +0300
Message-ID: <20120524075125.GA2232@calypso>
References: <CAHsgog=k-NACuYbQRrOYJjqE1Nhj8+pZDrQaED0=etbCQCB-hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHsgog=k-NACuYbQRrOYJjqE1Nhj8+pZDrQaED0=etbCQCB-hA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hector Abrach <habrach-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Hector,

Do you see any errors/warnings in the SM's log, when you run opensm with high
verbosity (>VERBOSE)?

On 14:51 Wed 23 May     , Hector Abrach wrote:
> Hello,
> 
> I was hoping you could help me if at all just give me some pointers as
> to what my problem may be.
> 
> I have a problem with a ConnectX Infiniband driver where the driver
> port is stuck in INIT.
> Would you happen to know in exactly what file and function the port is
> changed from INIT -> ARMED -> ACTIVE? this would be of huge help.
> I believe this is the responsibility of the SM correct?
> 
> I always get a timeout on function dev_poll. Would you happen to know
> what it maybe polling for that is failing? I read on google something
> about mkeys but I'm shooting in the dark. I would really appreciate it
> if you could point me in the right direction.
> 
> I've noticed that in a working driver function smp_snoop() calls
> function update_sm_ah() in my case the if statement within smp_snoop
> is not being entered, could this be the problem?
> 
> I'm porting a Linux driver to work under QNX. I have a working MTHCA
> driver but this new MLX4 is causing me the trouble mentioned above. I
> feel that if I can get it to the ACTIVE state it may finally work.
> I would really appreciate any help/pointers you can give me. Thank you
> for your help and your time!!
> 
> Hector Abrach
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
