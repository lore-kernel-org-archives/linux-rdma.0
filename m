From: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: install.pl "chown" issue (Was: Re: rhel6 ofed v1.5.3)
Date: Mon, 11 Jul 2011 09:28:14 -0400
Message-ID: <CABOsP2MbNq6Yqc6+DKes==gim1dk3oipCL6H5zN6EiMGJhOCOg@mail.gmail.com>
References: <BANLkTi=fJr7BypNCs-7S4-THNTUGtmiicg@mail.gmail.com>
	<20110705153618.c7cba778.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110705153618.c7cba778.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 5, 2011 at 6:36 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Fri, 1 Jul 2011 10:08:47 -0700
> Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> According to my installation of Ofed 1.5.3 on RHEL6, the
>> infiniband-diags package rpm is trying to chown /usr/local in order =
to
>> deposit a library in lib64.
>
> infiniband-diags does not do a chown.

Sorry for the late reply, your reply got lost in my email bins...

I should correct my statement, when RPM does the cpio extraction of
the data that's what's reporting the error

>> In my environment /usr/local is off-limits to root and all package
>> installs. =A0Is this a bug? =A0Is there a workaround to allow the
>> install.pl to complete?
>
> I just tried this on a vanilla Fedora 15 system and was able to build=
 the source rpms just fine.
>
> Try building and installing in this order.
>
> libibumad-1.3.7-1.src.rpm
> libibmad-1.3.7-1.src.rpm
> opensm-3.3.9-1.src.rpm
> infiniband-diags-1.5.8-1.src.rpm

these all build correctly using the install.pl file upto the
infiniband-diags file then i get

error: unpacking archive file on file /usr/local: cpio: Operation not s=
upported
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
