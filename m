From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
Date: Wed, 16 Mar 2016 11:47:39 -0400
Message-ID: <20160316154738.GA26530@phlsvsds.ph.intel.com>
References: <20160315155441.222586021@linux.com> <20160315155455.173645653@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160315155455.173645653-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 15, 2016 at 10:54:42AM -0500, Christoph Lameter wrote:
 
>+static ssize_t show_protocol_stats(struct ib_device *dev, int index,
>+				   u8 port, char *buf)
>+{
>+	struct rdma_protocol_stats stats = {0};
>+	ssize_t ret;
>+
>+	ret = dev->get_protocol_stats(dev, &stats, port);
>+	if (ret)
>+		return ret;
>+
>+	return sprintf(buf, "%llu\n", stats.value[index]);
>+}

This works fine when there are few counters, but if there are lots? What 
about changing things to include the index in the get_protocol_stats() call 
so that we just grab the single item we are looking for?

>+static struct attribute_group *create_protocol_stats(struct ib_device 
>*device,
>+						     struct kobject *kobj,
>+						     u8 port) {
>+	struct attribute_group *ag;
>+	struct rdma_protocol_stats stats = {0};
>+	u32 counters;
>+	u32 i;
>+	int ret;
>+
>+	ret = device->get_protocol_stats(device, &stats, port);
>+
>+	if (ret || !stats.name)
>+		return NULL;
>+
>+	ag = kzalloc(sizeof(*ag), GFP_KERNEL);
>+	if (!ag)
>+		return NULL;
>+
>+	ag->name = stats.dirname;
>+
>+	for (counters = 0; stats.name[counters]; counters++)
>+		;
>+
>+	BUG_ON(counters > MAX_NR_PROTOCOL_STATS);

Should we really be bringing the machine crashing down here?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
