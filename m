From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] mlx5: Add support for sending IPoIB packets
Date: Thu, 7 Sep 2017 11:57:32 +0300
Message-ID: <f44e89bc-5916-f07a-5cf0-77f3f5bd4f4c@dev.mellanox.co.il>
References: <1504708729-15249-1-git-send-email-yishaih@mellanox.com>
 <1504708729-15249-4-git-send-email-yishaih@mellanox.com>
 <20170906160443.GC6262@obsidianresearch.com>
 <4151c1be-89f3-804f-8feb-5e2b0b3947bc@dev.mellanox.co.il>
 <20170906165334.GA12002@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170906165334.GA12002-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/6/2017 7:53 PM, Jason Gunthorpe wrote:
> On Wed, Sep 06, 2017 at 07:49:03PM +0300, Yishai Hadas wrote:
>
>> The commentary was focused on IPoIB as this is the main use case that we
>> come to solve.
>
> It is more than that, why does mlx5_post_send_underlay refer to
> things like MLX5_IPOIB_INLINE_MAX_HEADER_SIZE ? Those constants seem
> mis-named.
>
> And then there are comments like this:
>
>> /* We expect at least 4 bytes as part of first entry to hold the IPoIB header */
>
> Which really doesn't sound general at all.

The specific IPoIB handling as of copying from the application gather 
data into the header is some device limitation to support sending IPoIB 
packets. This is not required in the general case but will work as well. 
Future devices may work properly without that need, once be ready we may 
have some device capability exposed from kernel and clean this specific 
handling. Will update commit log to include this information as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
