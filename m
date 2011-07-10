From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add support for partition enforcement types
Date: Sun, 10 Jul 2011 14:26:26 +0300
Message-ID: <20110710112626.GC8520@localhost.localdomain>
References: <4E135D51.3080208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E135D51.3080208-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 14:52 Tue 05 Jul     , Hal Rosenstock wrote:
> 
> Partition enforcement types are in, out, and both.
> Prior to this support, both was being used so that is the default.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

Now we end up with two parameters for same functionality:
no_part_enforce - you define whether the enforcement is disabled or enabled.
part_enforcement_type - you define enforcement type: in/out/both.

When no_part_enforce is disabled, part_enforcement_type has no meaning.

Don't you find it simpler if we had only one option for partition enforcement
with 4 options: disabled/in/out/both(default)?

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
