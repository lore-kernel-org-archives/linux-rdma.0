From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Fri, 19 Jun 2015 07:53:19 -0400
Message-ID: <558402AF.1030902@dev.mellanox.co.il>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com> <1433615915-24591-15-git-send-email-ira.weiny@intel.com> <HE1PR05MB1418BB6C461790B76D9C02A3B1BD0@HE1PR05MB1418.eurprd05.prod.outlook.com> <1433961446.71666.26.camel@redhat.com> <20150610185653.GA28153@obsidianresearch.com> <1433966378.71666.44.camel@redhat.com> <HE1PR05MB141885494D6967919DAE135EB1BC0@HE1PR05MB1418.eurprd05.prod.outlook.com> <557AEB5D.1040003@redhat.com> <HE1PR05MB14182DCD7003B52A28BB62A5B1B90@HE1PR05MB1418.eurprd05.prod.outlook.com> <557E6514.1060600@redhat.com> <HE1PR05MB1418C8F8E54FCC790B0CCAE3B1A70@HE1PR05MB1418.eurprd05.prod.outlook.com> <953CDD5A-2738-4427-B763-EBFB4BBB2E03@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <953CDD5A-2738-4427-B763-EBFB4BBB2E03-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/18/2015 5:00 PM, Doug Ledford wrote:
> There is *zero* functional difference between node_type == OPA or node_type == IB_CA and link_layer == OPA. 
> An application has *exactly* what they need

We have neither of these things in the kernel today. Also, if I interpreted what was written by first Ira and more recently Sean, even if either of these things were done, the user space provider library for OPA might/could just change these back to the IB types.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
