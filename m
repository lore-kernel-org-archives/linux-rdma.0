From: Alaa Hleihel <alaa-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v5 00/26] New fast registration API
Date: Sun, 01 Nov 2015 17:06:51 +0200
Message-ID: <56362A8B.5030200@dev.mellanox.co.il>
References: <1444752709-15429-1-git-send-email-sagig@mellanox.com>	<56262676.7000403@dev.mellanox.co.il>	<563185AC.10804@redhat.com>	<CAJ3xEMjYd2WUzFxNNSvWCkedt0bczC3H2ySP0ACvEkaoUP2SGw@mail.gmail.com>	<56322A41.9050004@redhat.com> <CAJ3xEMjDpELFd5rMgRwtL4JhB_uHca6oE28exKamXUm4rmkrtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjDpELFd5rMgRwtL4JhB_uHca6oE28exKamXUm4rmkrtg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

hi

On 11/1/2015 17:00, Or Gerlitz wrote:
> On Thu, Oct 29, 2015 at 4:16 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On 10/29/2015 01:42 AM, Or Gerlitz wrote:
>>> On Thu, Oct 29, 2015 at 4:34 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>> Yes, I've pulled this in for 4.4.  Thanks!
>>> Doug, we want to run regression over the 4.4 bits, when do you expect
>>> for them to show up @ your kernel.org tree?
>> Sorry, when the fast registration API caused compile failure yesterday I
>> stopped at it and forgot to push the result out.  So, I've removed the
>> last patch of that series so it resolves the build breakage for now.  We
>> can add the last patch back in after the staging drivers are fixed up.
>> The result has been pushed to both github and k.o.
>>
>>> some of them are there but
>>> @ least 3-4 series which you said "applied" aren't, AFAIR last time it
>>> was only about whole ten days after the merge window opened. Also,
>>> without the patches being there the code isn't subject to linux-next
>>> merge test (also after being there neither, since the branch name
>>> changes for each release and I didn't see you setting a flying tag, or
>>> you did so?)
>> Yes, I set a flying tag as you call it.
> Doug, can you please re-spare few words on how this works?
>
> Stephen, is the framework for linux-next merge tests OK with this tag?
> can you confirm that the
> -next bits of the rdma tree are covered fine?
>
> Alaa, are you managing to follow on this tag for the MLNX internal
> builds? or you use manually the k.o/4.4 branch?
>
> Or.
>
Currently, I take the k.o/for-4.4 branch.

Alaa
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
