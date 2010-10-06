From: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Subject: Re: git dead?
Date: Wed, 6 Oct 2010 15:44:31 -0700
Message-ID: <4CACFBCF.3030802@nasa.gov>
References: <AANLkTinKZbW2tE5dw7nGuhcQTRq-iFSTkh6N7tfuNowW@mail.gmail.com>	<2EFBCAEF10980645BBCFB605689E08E904A5A38EE7@azsmsx506.amr.corp.intel.com> <AANLkTim9DUs79j1G3QZ1yK=VNnN=xHLYUP3MkUiRcuPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim9DUs79j1G3QZ1yK=VNnN=xHLYUP3MkUiRcuPQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 On 10/06/10 15:39, Josh England wrote:
> On Wed, Oct 6, 2010 at 1:19 PM, Tung, Chien Tin
> <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>> Something looks hosed.
>>> http://www.openfabrics.org/git/  gives me an Internal Server Error and
>>> I can't do a git clone.
>> Try http://git.openfabrics.org/git/
> Doesn't work either:
>
> $ git clone http://git.openfabrics.org/git
> Initialized empty Git repository in /home/josh/src/tmp/git/.git/
> warning: remote HEAD refers to nonexistent ref, unable to checkout.

You need the project repo, e.g.,
http://git.openfabrics.org/git/ofed_1_5/linux-2.6.git

-jeff
> -JE
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
