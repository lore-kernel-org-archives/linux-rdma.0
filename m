From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 1/2] libibnetdisc: Convert to a multi-smp algorithm
Date: Tue, 13 Apr 2010 16:25:31 +0300
Message-ID: <20100413132531.GI10830@me>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
 <20100413104658.GA10830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100413104658.GA10830@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13:46 Tue 13 Apr     , Sasha Khapyorsky wrote:
> 
> However see some comments and questions below.

Another thought. What about API like:

	ibnd_discover_fabric(cosnt char *ca_name, unsigned port_num,
			     struct ibnd_config *cfg);

So libibnetdisc will be responsible for opening and closing its own port
and in this way will be fully reenterable?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
