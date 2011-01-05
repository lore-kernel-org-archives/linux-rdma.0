From: Jabe <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Subject: What is OFED? (vs in-kernel drivers)
Date: Wed, 05 Jan 2011 13:24:33 +0100
Message-ID: <4D246301.40006@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Excuse the newbie question...
What is the relationship between OFED and in-kernel infiniband drivers?
Is ofed the source of merges? If yes, why is there need for an external 
development this time, why are drivers not developed within the kernel 
like it is for all other drivers?
Is there more stuff in ofed than there is in the kernel? I see mellanox 
docs reporting that in order to flash the firmware of their cards you 
need ofed installed...
Do I need to delete in-kernel drivers if I install ofed?
I am on ubuntu + vanilla kernel. What is the suggested approach to 
install ofed in ubuntu? I see there are rpms but not debs: should I go 
with git?

Thank you
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
