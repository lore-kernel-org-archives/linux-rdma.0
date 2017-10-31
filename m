From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Tue, 31 Oct 2017 10:20:42 -0500
Message-ID: <5ab2d58d-8af8-c075-86f0-7010b8316cba@mellanox.com>
References: <20171029191114.GO16127@mtr-leonro.local>
 <CALpBJjoJpgR1QB-gzRJLOjGtjK4T2H4EbG1-R+ndodvznWkgwA@mail.gmail.com>
 <20171030071956.GU16127@mtr-leonro.local>
 <CALpBJjqWrXu3b12EG2-AWKwKs9v2q5pTf11rXSy04C-5dGta6A@mail.gmail.com>
 <20171030230156.GA4081@ziepe.ca>
 <VI1PR0502MB300860F7C004ABFB01079F53D15E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20171031042435.GB7961@ziepe.ca>
 <e2a2aa84-71ce-36f0-91af-0854b24d4a6a@dev.mellanox.co.il>
 <60de3bab-f294-dd11-bcae-d179115f7c31@mellanox.com>
 <20171031150901.GA9852@ziepe.ca> <20171031151521.GK16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171031151521.GK16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/31/2017 10:15 AM, Leon Romanovsky wrote:
> On Tue, Oct 31, 2017 at 09:09:01AM -0600, Jason Gunthorpe wrote:
>> On Tue, Oct 31, 2017 at 10:01:49AM -0500, Daniel Jurgens wrote:
>>
>>>>> Adding the new return sure makes alot of sense as well..
>>>>>
>>>>> Hal, Ira, would you check this routine too? kernel oops's are bad..
>>>> Patch looks needed for just the point that Parav made above (that if
>>>> security check fails, then ib_free_recv_mad will cause the
>>>> mad_recv_wc->rmpp_list to be accessed so it needs to be initialized
>>>> before security is enforced).
>>> Agree the patch is needed regardless.
>> Someone please send it..
> Parav/Daniel,
>
> Please send it directly to the mailing list.
>
>>>> I don't have mthca to try this. Maybe Chris can try this patch (with
>>>> CONFIG_SECURITY_INFINIBAND=y).
>>> Chris, are you running with SELinux enabled? If this addresses your issue it means permission is denied, so once the crash is resolved additional policy will be required in order for it to work as expected.
>> If Chris has selinux turned on in his distro would you expect this
>> test to just fail? Doesn't that mean we have missed installing security labels
>> for things like opensm?
> Chris has SELinux enabled, see his gist: https://gist.github.com/riptidewave93/b3b83c13e93ab3be4254c855885f5b3a

That doesn't indicate if he has SELinux enabled or not, just that CONFIG_SECURITY_INFINIBAND is enabled.  Also, even if SELinux enabled in the kernel config it must be turned on via /etc/selinux/config, and also set into enforcing mode, if it were to cause this problem.  There's no enough info there to determine any of that.

> Thanks
>
>> Jason


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
