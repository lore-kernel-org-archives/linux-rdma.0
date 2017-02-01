From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 00/10] Completion timestamping support in
 mlx4
Date: Wed, 1 Feb 2017 17:21:07 +0200
Message-ID: <9ca12450-a875-cbd1-c906-cc878d930172@dev.mellanox.co.il>
References: <1485877597-23845-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485877597-23845-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/31/2017 5:46 PM, Yishai Hadas wrote:
> Sending V1 to address few notes from Jason, details below.
>
> This series from Ariel implements the libibverbs 'Completion timestamping' API
> in the mlx4 provider.
>
> It implements the new iterator style CQ polling API with support of querying
> specific CQ fields, among them the completion timestamp.
>
> Benchmarks we ran in our test lab found that this new approach generally equals
> to the legacy API but *not* worse than. As the new API enables extending the
> polled fields we can overall say that it's a better API than the legacy one.
>
> Pull request was sent:
> https://github.com/linux-rdma/rdma-core/pull/61
>
> Yishai

Series was applied.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
