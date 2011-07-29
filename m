From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch infiniband-diags:perfquery] Loop through all local HCAs/ports
Date: Fri, 29 Jul 2011 18:04:07 -0400
Message-ID: <4E332E57.6010804@redhat.com>
References: <4E332CE5.3010706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E332CE5.3010706-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/29/2011 05:57 PM, Doug Ledford wrote:
+				if (umad_get_ca(name_list[cur_name], &ca))
+					/* We're done, the next name was
+					 * empty, just exit gracefully
+					 */
+					exit(0);

In retrosight, this may not exit quietly.  I can't tell because the last 
adapter in my system causes the program to exit noisily right now for 
totally unrelated reasons, so if I got that fixed, I may find this isn't 
as quite of an exit as I thought.  This may need to be changed to a 
check for a NULL name instead, on NULL exit quietly, and if non-NULL 
then attempt to get it, and then on failure be noisy.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
