From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 libmlx5 6/6] fix undefined uuar_index value assignment
Date: Thu, 28 Jul 2016 12:40:01 -0400
Message-ID: <20160728164001.GQ36313@redhat.com>
References: <1469647047-7544-7-git-send-email-jarod@redhat.com>
 <1469669515-23720-1-git-send-email-jarod@redhat.com>
 <828fc991-56e5-91e4-72e1-f10ca7c05aef@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <828fc991-56e5-91e4-72e1-f10ca7c05aef-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 28, 2016 at 06:53:36PM +0300, Yishai Hadas wrote:
> On 7/28/2016 4:31 AM, Jarod Wilson wrote:
> >In the case of (attr->comp_mask & MLX5_CREATE_QP_EX2_COMP_MASK) being not
> >true, uuar_index gets set to resp.uuar_index, but nothing ever initializes
> >resp.uuar_index.
> >
> >That said, both this case, and the true case, it looks like uuar_index
> >never gets assigned to anything but 0. In the true path, resp_ex gets
> >memset to 0, and then nothing ever sets uuar_index. Not sure what the
> >intended use was here, but ultimately, uuar_index is always going to be 0
> >with this patch (0 or undetermined garbage before).
> >
> >Additionally, I'm not sure if the cmd and resp size parameters passed to
> >ibv_cmd_create_qp_ex() are correct, but they're at least larger than they
> >might be, which should be fine. I think. But I'm just guessing here.
> 
> In both cases the data comes back from the kernel driver in the
> vendor channel path and uuar_index gets a real value. That's why
> ibv_cmd_create_qp_ex gets resp_size which is really larger than
> struct ibv_create_qp_resp which holds the output from the IB layer.
> 
> No change is needed here.

Hm. Well, coverity and clang dislike the current state, and this patch
does make them happy, but I suppose I can be persuaded to ignore them.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
