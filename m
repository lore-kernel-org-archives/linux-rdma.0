From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
 'ibcheckspeed' and 'ibcheckportspeed' to scripts
Date: Tue, 15 Sep 2009 09:41:57 -0700
Message-ID: <20090915094157.1bd6d06b.weiny2@llnl.gov>
References: <829ded920909100602h78614ac0jd4eb1ee8d7a3779b@mail.gmail.com>
	<f0e08f230909100623k75d69e52m965628c3305f2125@mail.gmail.com>
	<20090910090213.6888b7d5.weiny2@llnl.gov>
	<829ded920909102102o49f037cbhc53a849f1fcfdaa4@mail.gmail.com>
	<20090914110221.7e33b737.weiny2@llnl.gov>
	<f0e08f230909141151g6e0df176tcb9bca2c040c06c7@mail.gmail.com>
	<4AAF8883.1020900@gmail.com>
	<829ded920909150541l5505ac0etf18d1937cb54eff1@mail.gmail.com>
	<4AAF90D8.6070403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AAF90D8.6070403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OFED mailing list <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 15 Sep 2009 16:04:24 +0300
"Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Keshetti Mahesh wrote:
> >> Also it would be useful to find all ports in Disable state.
> > 
> > iblinkinfo already does this with '-d' option.
> > 
> It shows all the port that are in Down state - either cable disconnected or port disabled (by ibportstate).
> 
> Eli
>

The -l option was designed to show all the info for each link on a single line to be grepped.  So to look for Disabled links on a 1152 node ftree cluster.

09:37:31 > time ./iblinkinfo -l | grep Disable

real    0m3.041s
user    0m0.026s
sys     0m0.039s

Eli, If you have data for this being slow on a larger cluster I would be interested to know.  

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
