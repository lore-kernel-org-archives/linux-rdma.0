From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-core] Add a .travis.yml file
Date: Wed, 5 Oct 2016 09:39:42 -0700
Message-ID: <0de7bc15-5e2e-8240-ba84-a5a95dcb2834@sandisk.com>
References: <1475105337-18002-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <20161005115132.GE9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161005115132.GE9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/05/2016 04:51 AM, Leon Romanovsky wrote:
> On Wed, Sep 28, 2016 at 05:28:57PM -0600, Jason Gunthorpe wrote:
>> Necessary to use the Travis CI service.
>>
>> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>> ---
>>  .travis.yml | 28 ++++++++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
>>  create mode 100644 .travis.yml
>>
>> Now that travis is enabled on repo, we need a yml file to make it run.
>>
>> Here is a basic one.
>>
>> I don't test with distros as old as precise and I don't expect that glibc to
>> be new enough to build this (eg missing timerfd, O_CLOEXEC, etc), and the
>> cmake certainly isn't. So we use the trusty 'beta' environment and install
>> gcc 6.2.
>
> I'm using 16.04 and it has gcc 5.4.0 as a default. Don't you think that
> 6.2 is too "new" for us and other distributions?

Hi Leon,

The rolling release distro that is running on my laptop includes gcc 6.2.1.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
