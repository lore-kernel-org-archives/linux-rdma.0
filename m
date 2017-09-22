From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] rdma/core: Don't dereference device->get_link_layer
 directly
Date: Fri, 22 Sep 2017 13:23:22 -0400
Message-ID: <1506101002.5172.9.camel@redhat.com>
References: <1505908483-29641-1-git-send-email-sagi@grimberg.me>
         <F3529576D8E232409F431C309E29399336CD902F@CRSMSX102.amr.corp.intel.com>
         <20170920134723.GO5788@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170920134723.GO5788-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-09-20 at 16:47 +0300, Leon Romanovsky wrote:
> On Wed, Sep 20, 2017 at 12:33:39PM +0000, Estrin, Alex wrote:
> > Patch for this issue was already posted about 3 weeks ago.
> > https://patchwork.kernel.org/patch/9932505/
> 
> Yeah, exactly.
> I had a dejavu while I read the "crash IPoIB" report.
> 
> I assume that it didn't make to Linus, because it was posted after
> Doug
> went to vacation.

I wouldn't call it "vacation" ;-).  I had no internet as I was moving
homes.  It was hardly the peaceful, relaxing experience one hopes to
get on vacation! :-)

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
