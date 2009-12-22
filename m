From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] tests/subnet_discover: discover test utility
Date: Tue, 22 Dec 2009 13:27:47 +0200
Message-ID: <20091222112747.GB26940@me>
References: <20090813204306.dffc3237.weiny2@llnl.gov>
 <20090816110200.GS25501@me>
 <20090817083023.da17378b.weiny2@llnl.gov>
 <20090823120609.GG9547@me>
 <20090826164026.8dcce4b2.weiny2@llnl.gov>
 <20091023234349.GK5764@me>
 <20091220121406.GF5262@me>
 <20091220182809.f7e17fae.weiny2@llnl.gov>
 <20091221073550.GB18524@me>
 <f0e08f230912210602i5e3f528h2b0630420346db82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230912210602i5e3f528h2b0630420346db82-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09:02 Mon 21 Dec     , Hal Rosenstock wrote:
> > I wouldn't call it so, it is rather "parallel" than "first" depth or
> > breath - discovery continues at first responding node doesn't matter how
> > was it queried in depth or in breath.
> 
> Does anything limit the amount of parallelism ?

Nothing in this version.

> > I think so. The difference is that OpenSM has a limit of outstanding
> > MADs on the wire and subnet_discover doesn't (and there could be a lot
> > of MADs).
> 
> Isn't that dangerous in a real subnet ?

This is test tool, so I don't think that it is "dangerous". And of
course this can lead to an issues with test results.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
