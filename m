From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] util: Fix check_snprintf to use __rc__ for
 local
Date: Fri, 1 Sep 2017 09:47:33 -0600
Message-ID: <20170901154733.GA11102@obsidianresearch.com>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1504212659-9674-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170901045632.GJ10539@mtr-leonro.local>
 <20170901150013.GA21378@obsidianresearch.com>
 <1504278799.14386.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1504278799.14386.1.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org" <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 01, 2017 at 03:13:20PM +0000, Bart Van Assche wrote:

> > #define check_snprintf(buf, len, fmt, ...)    \
> > 	__good_snprintf(len, snprintf(buf, len, fmt, ##__VA_ARGS__))
> 
> If an inline function will be introduced anyway, why not to make check_snprintf()
> itself an inline function and use vsnprintf() instead of snprintf()?

Well.. Generally speaking I prefer to avoid wrappering 'magic'
functions like snprintf with inlines because you loose the 'magic'.

eg, however it is done, modern gcc triggers -Wformat-length analysis
for snprintf, and if you wrapper it with an inline it appears that
analysis is lost. This is separate from the well known
attribute((printf)).

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
