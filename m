From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] IB/srpt: Convert use of __constant_cpu_to_beXX to cpu_to_beXX
Date: Tue, 23 Jun 2015 07:35:33 -0700
Message-ID: <55896EB5.4030307@sandisk.com>
References: <20150623044153.GA21400@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150623044153.GA21400@vaishali-Ideapad-Z570>
Sender: linux-kernel-owner@vger.kernel.org
To: Vaishali Thakkar <vthakkar1994@gmail.com>, Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 06/22/15 21:41, Vaishali Thakkar wrote:
>   	if (!slot || slot > 16) {
>   		mad->mad_hdr.status
> -			= __constant_cpu_to_be16(DM_MAD_STATUS_INVALID_FIELD);
> +			= cpu_to_be16(DM_MAD_STATUS_INVALID_FIELD);
>   		return;
>   	}

Without this change several statements exceeded 80 characters and were 
split because of that reason. Please change the multi-line statements 
that have been reduced to less than 80 columns into single-line statements.

Bart.
