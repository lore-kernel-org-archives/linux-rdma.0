From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v1 00/24] New fast registration API
Date: Tue, 29 Sep 2015 12:03:53 -0700
Message-ID: <560AE099.2080004@sandisk.com>
References: <1442482947-27785-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442482947-27785-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/17/2015 02:42 AM, Sagi Grimberg wrote:
> - Converted SRP initiator and RDS iwarp ULPs to the new API

Hello Sagi,

How has the converted SRP initiator driver been tested ? With the kernel 
tree that is available on branch reg_api.4 
(427def03e9fa9801efbb27f6c3c6bf7fc0d012e1) I see on the initiator system 
that login fails and that the following message is logged:

Sep 29 12:01:05 ion-dev-ib-ini kernel: scsi host72: ib_srp: failed 
receive status WR flushed (5) for iu ffff88045bb80930

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
