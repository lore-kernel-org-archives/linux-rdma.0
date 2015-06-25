From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V5 1/5] IB/uverbs: Fix reference counting usage
 of event files
Date: Thu, 25 Jun 2015 14:46:02 +0300
Message-ID: <558BE9FA.9060402@dev.mellanox.co.il>
References: <1434984438-21733-1-git-send-email-yishaih@mellanox.com> <1434984438-21733-2-git-send-email-yishaih@mellanox.com> <20150624175738.GC21033@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150624175738.GC21033-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/24/2015 8:57 PM, Jason Gunthorpe wrote:
> On Mon, Jun 22, 2015 at 05:47:14PM +0300, Yishai Hadas wrote:
>>   	fd_install(resp.async_fd, filp);
>> @@ -386,6 +376,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
>>   	return in_len;
>>
>>   err_file:
>> +	ib_uverbs_free_async_event_file(file);
>>   	fput(filp);
>
> This looks really weird.

We need to cleanup all by that step otherwise we might leak that async 
file, see my last comment below which clarifies that point.
As ib_uverbs_release_event_file is static function in uverbs_main it 
makes sense to expose this cleanup function similar to 
ib_uverbs_alloc_event_file which is exposed from uverbs_main and make 
the allocation.

>> +void ib_uverbs_free_async_event_file(struct ib_uverbs_file *file)
>> +{
>> +	kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
>> +	file->async_file = NULL;
>> +}
>
> So that put is supposed to pair with this get?
Yes

>
>> +		uverbs_file->async_file = ev_file;
>> +		kref_get(&uverbs_file->async_file->ref);
>
> [..]
>
>> +	fput(filp);
>> +	uverbs_file->async_file = NULL;
>
> But isn't it null?
>

No, this NULL is set when ib_uverbs_alloc_event_file failed internally, 
the above flow occurs when file was created OK but later it fails via 
copy_to_user.

> Again again, WTF? async_file is a kref'd thing, if you copy or assign
> to it you need to manipulate the kref, so the null assign should be
> dropping the ref.
>

The logic in ib_uverbs_alloc_event_file if kref oriented, the original 
code which uses free didn't follow this convention, currently in case 
ib_uverbs_alloc_event_file failed internally it uses 
kref_put(&ev_file->ref, ib_uverbs_release_event_file) which internally 
frees the memory, in case we had an error after that the file was 
created (e.g ib_register_event_handler) need to use fput(filp) to make 
an extra cleanup which again uses ref count handling.
The uverbs_file->async_file = NULL command just cleans the previous 
setting of uverbs_file->async_file = ev_file that was done before to 
prevent it be cleanup when the uverbs_file itself is closed.

> Whis looks good enough to remove ib_uverbs_free_async_event_file, if
> the flip is created OK then the uverbs_file->async file can remain set
> until the uverbs file is closed.

This is wrong, as file->ucontext is NULL because of the failure in 
copy_to_user, application might recall to ib_uverbs_get_context in that 
case we leak that previous async_file, that's why the code must cleanup 
and put NULL by that step. To your request put 
WARN_ON(uverbs_file->async_file) as part of ib_uverbs_alloc_event_file 
to make sure that we don't hit that case.

This patch fixes a bug that currently exists upstream that you pointed 
on that may cause an oops, hope that above clarifies the issues and you 
can ACK on.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
