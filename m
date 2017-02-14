From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: v4.10-rc SRP + mlx5 regression
Date: Tue, 14 Feb 2017 09:29:33 -0800
Message-ID: <36ef0c01-4d71-9922-e63d-5439d3415b2f@sandisk.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
 <21338434.30712464.1487004451595.JavaMail.zimbra@redhat.com>
 <1301607843.30852658.1487021644535.JavaMail.zimbra@redhat.com>
 <898197116.30855343.1487022400065.JavaMail.zimbra@redhat.com>
 <1487022735.2719.7.camel@sandisk.com>
 <568916592.30910570.1487038794766.JavaMail.zimbra@redhat.com>
 <20170214063953.GF6989@mtr-leonro.local>
 <bfca98d3-3f74-c370-7455-71e2ebd583e9@mellanox.com>
 <656778124.31118982.1487079062235.JavaMail.zimbra@redhat.com>
 <a7ae2926-da0a-edf9-7779-09a6edd54d5d@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a7ae2926-da0a-edf9-7779-09a6edd54d5d-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/14/2017 09:15 AM, Max Gurtovoy wrote:
> this is 4MB transactions. can you increase the cmd_sg_entries to the
> maximum and run the test again ?

How could that affect the error message Laurence reported? If
cmd_sg_entries is too low then the block layer refuses direct I/O
requests that are too large. From __scsi_init_queue():

	blk_queue_max_segments(q, min_t(unsigned short,
					shost->sg_tablesize,
					SG_MAX_SEGMENTS));

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
