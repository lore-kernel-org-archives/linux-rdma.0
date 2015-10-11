From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: libibverbs-1.2.0-rc1 release
Date: Sun, 11 Oct 2015 17:00:39 +0300
Message-ID: <561A6B87.9010702@dev.mellanox.co.il>
References: <5602DB41.5070700@redhat.com>
 <CAJ3xEMjZaG-1oej4nBG4QhEV-TdGtMp0ZiT2m_2A1_ii2wRZpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjZaG-1oej4nBG4QhEV-TdGtMp0ZiT2m_2A1_ii2wRZpg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/11/2015 12:51 PM, Or Gerlitz wrote:
> On Wed, Sep 23, 2015 at 8:02 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> I have done a pre-release of the upcoming libibverbs-1.2.0 release.  The
>> code has been pushed to the official git repo and also an -rc1 tarball
>> uploaded to the https://ww.openfabrics.org/downloads/verbs download
>> area.  From the tag message:
>
> Doug, so when is this release expected to happen? the last release
> took place in 2014.

Doug, please be aware that currently there is a problem to build an rpm 
from the libibverbs git repository.

Major version number can't have hyphen "-". (e.g. "-rc1").
Also, version should be updated in libibverbs.spec.in.
You can use latest commits to libmlx4 as some reference for correct 
usage. (i.e. http://git.openfabrics.org/?p=~yishaih/libmlx4.git;a=summary).


> Yishai, are you expecting anything to be added to libmlx4 for your
> upcoming release?
No, the official libmlx4 git-repository is-up-to-date with the candidate 
stuff.

> if not, I guess you can sign it already against 1.2.0-rc1, right?
When there will be a formal release of libibverbs after fixing above 
issue, I'll build a matching libmlx4 tar ball.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
