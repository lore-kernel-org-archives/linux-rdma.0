From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V1 3/9] IB/core: Add gid attributes to sysfs
Date: Tue, 24 Nov 2015 15:49:28 +0200
Message-ID: <CAAKD3BA=h+Mpq9VBnCNpv0UCAkmwCBtOahpOhhWdCvUM=C7JPw@mail.gmail.com>
References: <1444925232-13598-1-git-send-email-matanb@mellanox.com>
	<1444925232-13598-4-git-send-email-matanb@mellanox.com>
	<20151123212029.GB6062@obsidianresearch.com>
	<CAAKD3BCQzBax6N3+-RhdEvByQu3mz1KKsjQ7yjs-fn2_nSPfOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BCQzBax6N3+-RhdEvByQu3mz1KKsjQ7yjs-fn2_nSPfOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 24, 2015 at 10:31 AM, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On Mon, Nov 23, 2015 at 11:20 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> On Thu, Oct 15, 2015 at 07:07:06PM +0300, Matan Barak wrote:
>>> This patch set adds attributes of net device and gid type to each GID
>>> in the GID table. Users that use verbs directly need to specify
>>> the GID index. Since the same GID could have different types or
>>> associated net devices, users should have the ability to query the
>>> associated GID attributes. Adding these attributes to sysfs.
>>
>> There is no addition to Documentation/ABI/ for this change
>>
>
> Do we have documentation for our sysfs ABI in the Documentation directory?
> Grepping for infiniband there only found sysfs-driver-ib_srp, which
> isn't the right place to add these things.
>

Of course that if there is no such documentation, I can add a new file
for the sysfs ABI defined in this patch.

>> Jason
>
> Matan
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
