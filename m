From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v5 00/26] New fast registration API
Date: Thu, 29 Oct 2015 16:33:29 +0200
Message-ID: <56322E39.6020602@dev.mellanox.co.il>
References: <1444752709-15429-1-git-send-email-sagig@mellanox.com>
 <56262676.7000403@dev.mellanox.co.il> <563185AC.10804@redhat.com>
 <CAJ3xEMjYd2WUzFxNNSvWCkedt0bczC3H2ySP0ACvEkaoUP2SGw@mail.gmail.com>
 <56322A41.9050004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56322A41.9050004-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 29/10/2015 16:16, Doug Ledford wrote:
> On 10/29/2015 01:42 AM, Or Gerlitz wrote:
>> On Thu, Oct 29, 2015 at 4:34 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> Yes, I've pulled this in for 4.4.  Thanks!
>>
>> Doug, we want to run regression over the 4.4 bits, when do you expect
>> for them to show up @ your kernel.org tree?
>
> Sorry, when the fast registration API caused compile failure yesterday I
> stopped at it and forgot to push the result out.  So, I've removed the
> last patch of that series so it resolves the build breakage for now.  We
> can add the last patch back in after the staging drivers are fixed up.
> The result has been pushed to both github and k.o.

I can provide a patch for hfi, anything else needed?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
