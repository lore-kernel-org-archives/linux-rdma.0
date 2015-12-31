From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re:
 git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git/k.o/for-4.5
 crash during boot
Date: Thu, 31 Dec 2015 09:48:05 +0100
Message-ID: <5684EBC5.6040702@sandisk.com>
References: <5683C863.4040209@sandisk.com> <5683CC7F.5020301@mellanox.com>
 <20151230123428.GB10271@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151230123428.GB10271-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/30/2015 01:34 PM, Leon Romanovsky wrote:
> On Wed, Dec 30, 2015 at 02:22:23PM +0200, Or Gerlitz wrote:
>> On 12/30/2015 2:04 PM, Bart Van Assche wrote:
>>> Hello Christoph,
>>>
>>> Can you check whether the branch in the subject of this e-mail works fine
>>> on your setup (commit 59caaed7a7) ? On my test setup (Dell R430 with two
>>> ConnectX-3 adapters) this branch crashes during boot in
>>> get_counter_table() (see also the attached screenshot).
>>
>> Can you please check with Hal's fix that was posted here 1-2 days ago,
>> hopefully this should make your system to work
>
> Or referenced to this patch [1], it should fix your crash.
>
> [1] https://patchwork.kernel.org/patch/7929551/

Hello Or and Leon,

That patch indeed fixes the crash I had reported.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
