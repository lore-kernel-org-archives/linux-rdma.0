From: "Carr, Jared F" <jared.carr-MIjBx5DB8Ok@public.gmane.org>
Subject: Re: [PATCH] OpenSM - Scatter Ports
Date: Thu, 24 Mar 2011 13:13:52 -0700
Message-ID: <C9B0E934.B0A4%jared.carr@pnnl.gov>
References: <1300991720.3128.210.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300991720.3128.210.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "Schmidt, Kenneth P" <kenneth.schmidt-Y2zl/4KMd60@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/24/11 11:35 AM, "Albert Chu" <chu11-i2BcT+NCU+M@public.gmane.org> wrote:

>Architecturally this seems very similar to my
>"port_shifting"/"remote_guid_sorting" patches I posted earlier.

Indeed they are very similar as it seems they are both intended to solve
the same or very similar problem. I think your approach has some
advantages in that it is potentially more deterministic, and it addresses
the lmc > 0 scenario.

In simulation the path balance on our topology ends up coming out with a
slightly better balance using scatter_ports than it does with
port_shifting. For instance the highest number of paths through a single
link using port shifting is 11895 and using scatter_ports it is 7121.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
