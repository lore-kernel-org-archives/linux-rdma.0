From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 00/10] Add tag matching support
Date: Sun, 29 Oct 2017 15:35:51 +0200
Message-ID: <44839721-f354-f2a3-7291-53ddc0cd8216@dev.mellanox.co.il>
References: <1508764681-4531-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508764681-4531-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/23/2017 4:17 PM, Yishai Hadas wrote:
> This patch set from Artemy is the supplementary part of the kernel series that
> was accepted upstream into 4.14 and enables the RDMA tag-matching offload to
> user space applications.
> 
> The verbs API follows an RFC [1] which included the verbs patches, man pages
> and a detailed documentation.
> 
> A detailed description of the concept and the API exist at
> Documentation/tag_matching.md which is built incrementally during the series
> and as part of the relevant man pages.
> 
> The series introduces the API and its matching implementation in mlx5 driver.
> 
> [1] https://www.spinics.net/lists/linux-rdma/msg50838.html
> 
> PR was sent:
> https://github.com/linux-rdma/rdma-core/pull/227
> 

The series followed a detailed RFC, was in the list for a week without 
any comment, merged.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
