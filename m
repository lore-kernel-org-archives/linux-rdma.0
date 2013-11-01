From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH RFC v2 00/10] Introduce Signature feature
Date: Fri, 01 Nov 2013 08:03:18 -0700
Message-ID: <5273C2B6.7010901@acm.org>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383222255-22699-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 31/10/2013 5:24, Sagi Grimberg wrote:
> In T10-DIF, when a series of 512-byte data blocks are transferred, each
> block is followed by an 8-byte guard. The guard consists of CRC that
> protects the integrity of the data in the block, and some other tags
> that protects against mis-directed IOs.

Shouldn't that read "logical block length divided by 2**(protection 
interval exponent)" instead of "512" ? From the SPC-4 FORMAT UNIT 
section: <quote>For a type 2 protection or a type 3 protection format 
request, the protection interval exponent determines the length of user 
data to be transferred before protection information is transferred 
(i.e., the protection information interval). The protection information 
interval is calculated as follows: protection information interval = 
logical block length / 2**(protection interval exponent) where:
logical block length is the number of bytes of user data in a logical 
block (see 4.5) and where protection interval exponent is zero if the 
short parameter list header (see table 36) is used or the contents of 
the PROTECTION INTERVAL EXPONENT field if the long parameter list header 
(see table 37) is used. If the protection information interval 
calculates to a value that is not an even number (e.g., 520 / 2**3 = 65) 
or not a whole number (e.g., 520 / 2**4 = 32.5 and 520 / 2**10 = 0.508), 
then the device server shall terminate the command with CHECK CONDITION 
status with the sense key set to ILLEGAL REQUEST and the additional 
sense code set to INVALID FIELD IN PARAMETER LIST.</quote>

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
