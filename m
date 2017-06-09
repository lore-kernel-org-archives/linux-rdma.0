From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Introduce flow steering drop action
Date: Fri, 09 Jun 2017 17:20:32 -0400
Message-ID: <1497043232.7171.226.camel@redhat.com>
References: <1496332034-14758-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496332034-14758-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-06-01 at 18:47 +0300, Yishai Hadas wrote:
> From: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This flow steering specification identifies a drop flow to the
> hardware.
> 
> If user creates a flow only with the drop specification, then all the
> packets that hit this flow will be dropped, otherwise the hardware
> will
> drop only the packets that match the other L2/L3/L4 specifications.
> 
> Signed-off-by: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
