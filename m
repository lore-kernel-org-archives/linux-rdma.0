From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs] Add QP creation flags, support blocking
 self multicast loopback
Date: Tue, 16 Feb 2016 16:47:07 +0200
Message-ID: <56C3366B.4080001@dev.mellanox.co.il>
References: <1455198849-32192-1-git-send-email-yishaih@mellanox.com>
 <56C2158D.50801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56C2158D.50801-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/15/2016 8:14 PM, Doug Ledford wrote:
> On 02/11/2016 08:54 AM, Yishai Hadas wrote:
>> From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Add QP creation flags, specifically add a flag to indicate that
>> the QP will not receive self multicast loopback traffic.
>>
>> To pass the QP creation flags to the kernel need to add
>> ibv_cmd_create_qp_ex2 API which follows the extended scheme
>> and uses the CREATE_QP_EX command.
>> ibv_cmd_create_qp_ex API doesn't follow the extended scheme,
>> it uses the CREATE_QP command and can't be used.
>
> I've been reviewing this patchset and this is just *ugly*.  This seems
> like an example of where proper gcc library symbol versions could be
> used to avoid this being so ugly.

In my understanding, you suggest to have in driver.h only one function 
ibv_cmd_create_qp_ex and use the symbol versions mechanism to have 
binary compatibility for legacy providers.

Before going to that approach need to consider below notes:
1) That approach breaks source comparability, re-compile legacy 
providers will fail as the signature of ibv_cmd_create_qp_ex is changed.
Current patch that we sent preserves also source compatibility.

2) Usually symbol versions comes to solve ABI compatibility with an 
application, here the application calls ibv_create_qp_ex and the 
decision which command to call is done under the wood by the driver.

3) In your approach will have also some *ugly* code around:
Need to hold the code of current ibv_cmd_create_qp_ex API for binary 
comparability, it will result in some extra compat file to be added to 
libibverbs (e.g. compat-1_1.c) increase DEFAULT_ABI, etc.

4) In your approach ibv_cmd_create_qp_ex code might be more *complex* 
comparing current code. As it needs to support also legacy kernel which 
doesn't have the CREATE_QP_EX command, it might include some *non clean* 
adaptation from the in/out parameters of its API which match to the EX 
scheme and adapt to the non EX scheme. Current suggestion have 2 APIs 
with the matching in/out parameters for.

I believe that we should consider staying with current patch, would 
appreciate your input on.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
