From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 01/24] mlx4-ib: Use coherent memory for priv pages
Date: Mon, 20 Jun 2016 16:41:35 +0300
Message-ID: <12ee28bb-b838-ed4c-5f84-0cb8f1760d63@dev.mellanox.co.il>
References: <20160616143518.GX5408@leon.nu> <576315C9.30002@gmail.com>
 <652EBA09-2978-414C-8606-38A96C63365A@oracle.com>
 <20160617092018.GZ5408@leon.nu>
 <4D23496A-FE01-4693-B125-82CD03B8F2D4@oracle.com>
 <20160618105650.GD5408@leon.nu>
 <5D0A6B47-CB71-42DA-AE76-164B6A660ECC@oracle.com>
 <57666E14.2070802@gmail.com>
 <CAJ3xEMha=i5SaM+fV5XP15Fx6pymrYnvk=a8w+3h1cbBeuVX0A@mail.gmail.com>
 <B62EEE84-454D-4D55-9C7E-653F564DF381@oracle.com>
 <20160620054453.GA1172@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160620054453.GA1172-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/20/2016 8:44 AM, Leon Romanovsky wrote:
> On Sun, Jun 19, 2016 at 04:02:23PM -0400, Chuck Lever wrote:
>>
>
> Thanks Chuck and Sagi for the help.
>
> <...>
>
>>
>>> I
>>> didn't see such note along the thread, basically, I think this is
>>> where we should be starting, thoughts? I also added the mlx4 core/IB
>>> maintainer.
>>
>> Yishai was notified about this issue on May 25:
>>
>> http://marc.info/?l=linux-rdma&m=146419192913960&w=2
>
> Yishai and me follow this thread closely and we work on finding the
> root cause of this issue.
>

Just found the root cause of the problem, it was found to be a hardware 
limitation that is described as part of the PRM. The driver code had to 
be written accordingly, confirmed that internally with the relevant people.

 From PRM:
"The PBL should be physically contiguous, must reside in a 
64-byte-aligned address, and must not include the last 8 bytes of a page."

The last sentence pointed that only one page can be used as the last 8 
bytes should not be included. That's why there is a hard limit in the 
code for 511 entries.

Re the candidate fix that you sent, from initial review it makes sense, 
we'll formally confirm it soon after finalizing the regression testing 
in our side.

Thanks Chuck and Sagi for evaluating and working on a solution.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
