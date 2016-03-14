From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2] IB/uverbs: Fix race between uverbs_close and
 remove_one
Date: Mon, 14 Mar 2016 17:55:23 +0200
Message-ID: <56E6DEEB.30904@dev.mellanox.co.il>
References: <1457343873-14869-1-git-send-email-devesh.sharma@broadcom.com>
 <20160307190833.GA1886@obsidianresearch.com>
 <CANjDDBiYagKm79n5sWNsCnxruSzqDqZYREmw1mGBR_upapF4hQ@mail.gmail.com>
 <20160308175334.GB10805@obsidianresearch.com>
 <56E053C8.8050008@dev.mellanox.co.il>
 <20160309190354.GD21139@obsidianresearch.com>
 <56E159CC.3090805@dev.mellanox.co.il>
 <20160310210535.GA9735@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160310210535.GA9735-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/10/2016 11:05 PM, Jason Gunthorpe wrote:
> On Thu, Mar 10, 2016 at 01:26:04PM +0200, Yishai Hadas wrote:
>
>>> No, I don't think that is true, the completion looks like it is
>>> actually needed because the goto out in ib_uverbs_close needs to wait
>>> for ib_uverbs_free_hw_resources to do the cleanups ib_uverbs_close
>
>>> skipped over before it can go ahead and kref_put things.
>> Why not ? the final cleanup as part of uverbs_close doesn't depend on ib_dev,
>> the kref should be fine for that. The race is *only* for
>> ib_uverbs_cleanup_ucontext that uses ib_dev and it should be solved as of
>> above suggestion.
>
> It has nothing to do with ib_dev, srcu doesn't lock the list:
>
> CPU 0                                   CPU 1
> rcu_assign_pointer(ib_dev, null)
> ib_uverbs_free_hw_resources()
> synchronize_srcu();
>                                          ib_uverbs_close()
>                                          srcu_read_lock
> 					.. goto out
> 					kref_put(file->ref) .. kfree(file)
> ib_uverbs_free_hw_resources()
> mutex_lock(&lists_mutex);
> while (!list_empty(&uverbs_dev->uverbs_file_list))
>    .. Boom, use after free of file->list ..
>
> Ie, as I said, we can't put until we know the list_del is done, and
> the goto skips over list_del.
>
> The completion is preventing the above scenario, can't remove it.

Why do we need the completion for that ? the race can be prevented by 
below flow as part of uverbs_close.

ib_uverbs_close()
{
..
struct ib_ucontext *ucontext = NULL;
+ struct ib_device *ib_dev;

+ srcu_read_lock(...)
+ ib_dev = srcu_dereference(...);
mutex_lock(&file->device->lists_mutex);
ucontext = file->ucontext;
file->ucontext = NULL;
- if (!file->is_closed) {
+ if (ib_dev) {
	list_del(&file->list);
	file->is_closed = 1;
}
mutex_unlock(&file->device->lists_mutex);
if (ucontext)
	ib_uverbs_cleanup_ucontext(file, ucontext);

+ srcu_read_unlock()
if (file->async_file)
	kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
...

}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
