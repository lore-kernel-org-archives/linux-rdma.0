From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 1/4] nfs: Define NFS_RDMA_PORT
Date: Wed, 6 Dec 2017 11:34:26 +0530
Message-ID: <CANjDDBiTSDfzvj6qLaeEf+-Jx=XA9W2rzA2wW_q45MfauwffPA@mail.gmail.com>
References: <20171204190904.18629.70341.stgit@manet.1015granger.net>
 <20171204191330.18629.77069.stgit@manet.1015granger.net> <CANjDDBg3qsn5oWzmTSi5e3eKJKkdEceh0GUTe+pFDAGCxkDqGg@mail.gmail.com>
 <06D33DF4-6BAC-411B-8A08-5098E52720C6@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <06D33DF4-6BAC-411B-8A08-5098E52720C6-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Oh! apologies if I was not clear what I wanted to say. I was thinking
this change will avoid the step to write the nfsrdma port number into
/proc/fs/nfsd/portlist file after starting the nfs server. This is
step is a part of configuring nfs-rdma server. However, for tcp such
entries are present by default in this file.

-Regards
Devesh

On Wed, Dec 6, 2017 at 12:19 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Dec 5, 2017, at 10:09 AM, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
>>
>> Hi Chuck,
>>
>> Will this change avoid the "echo rdma 20049" on the nfs server during
>> nfs server start?
>
> I'm not familiar with this issue. Is there a bug report ?
>
>
>> -Regards
>> Devesh
>>
>> On Tue, Dec 5, 2017 at 12:43 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>> The NFS/RDMA port assignment is specified in Section 9 of RFC 8267.
>>>
>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> ---
>>> include/uapi/linux/nfs.h |    1 +
>>> 1 file changed, 1 insertion(+)
>>>
>>> diff --git a/include/uapi/linux/nfs.h b/include/uapi/linux/nfs.h
>>> index 057d22a..946cb62 100644
>>> --- a/include/uapi/linux/nfs.h
>>> +++ b/include/uapi/linux/nfs.h
>>> @@ -12,6 +12,7 @@
>>>
>>> #define NFS_PROGRAM    100003
>>> #define NFS_PORT       2049
>>> +#define NFS_RDMA_PORT  20049
>>> #define NFS_MAXDATA    8192
>>> #define NFS_MAXPATHLEN 1024
>>> #define NFS_MAXNAMLEN  255
>
> --
> Chuck Lever
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
