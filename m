From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libmlx5 6/6] fix undefined uuar_index value assignment
Date: Wed, 27 Jul 2016 17:27:34 -0400
Message-ID: <20160727212734.GK36313@redhat.com>
References: <1469647047-7544-1-git-send-email-jarod@redhat.com>
 <1469647047-7544-7-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469647047-7544-7-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 27, 2016 at 03:17:27PM -0400, Jarod Wilson wrote:
> In the case of (attr->comp_mask & MLX5_CREATE_QP_EX2_COMP_MASK) being not
> true, uuar_index gets set to resp.uuar_index, but nothing ever initializes
> resp.uuar_index.
> 
> That said, both this case, and the true case, it looks like uuar_index
> never gets assigned to anything but 0. In the true path, resp_ex gets
> memset to 0, and then nothing ever sets uuar_index. Not sure what the
> intended use was here, but ultimately, uuar_index is always going to be 0
> with this patch (0 or undetermined garbage before).
> 
> Additionally, I'm not sure if the cmd and resp size parameters passed to
> ibv_cmd_create_qp_ex() are correct, but they're at least larger than they
> might be, which should be fine. I think. But I'm just guessing here.

Coverity actually still complains about this version, largely because it
thinks that perhaps the comp_mask could change between checks, and thus
you could still get an uninitialized resp. I'm reworking this one a bit to
solve this in a way that is cleaner.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
